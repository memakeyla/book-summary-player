//
//  StoreViewModel.swift
//  BookSummaryPlayer
//
//  Created by Veronika Medyanik on 04.09.2023.
//

import Foundation
import StoreKit
import Logger
import Domain

public typealias BookProduct = Product

class StoreViewModel: ObservableObject {

    @Published var availableProducts = [Product]()
    @Published var purchasedProducts = Set<Product>()
    @Published var purchaseError: ErrorMessage? = nil

    private var transactionListener: Task<Void, Error>?
    
    private var productIDs = [
        "book.oliver_twist"
    ]
    
    init() {
        transactionListener = listenForTransactions()

        Task {
            await requestProducts()
            // Must be called after the products are already fetched
            await updateCurrentEntitlements()
        }
    }

    // MARK: - Public Methods
    
    @MainActor
    func requestProducts() async {
        do {
            availableProducts = try await Product.products(for: productIDs)
        } catch {
            Log.error("Failed to fetch products: \(error)")
        }
    }
    
    @MainActor
    func purchase(_ product: Product) async {
        do {
            let result = try await product.purchase()
            switch result {
            case .success(.verified(let transaction)):
                // Update purchasedProducts on the main thread
                DispatchQueue.main.async {
                    self.purchasedProducts.insert(product)
                }
                await transaction.finish()
                purchaseError = nil
            case .userCancelled:
                purchaseError = nil
            default:
                purchaseError = .init(
                    error: NSError(
                        domain: "PurchaseError",
                        code: 0,
                        userInfo: [
                            NSLocalizedDescriptionKey: "Purchase failed"
                        ]
                    )
                )
            }
        } catch {
            Log.error("Purchase failed: \(error)")
            purchaseError = .init(error: error)
        }
    }

    func isProductPurchased(_ product: Product) -> Bool {
        return purchasedProducts.contains(where: { $0.id == product.id })
    }
    
    // MARK: - Private Methods

    private func handle(transactionVerification result: VerificationResult <Transaction>) async {
        switch result {
        case let.verified(transaction):
            guard let product = self.availableProducts.first(where: {
                $0.id == transaction.productID
            }) else {
                return
            }
            // Update purchasedProducts on the main thread
            DispatchQueue.main.async {
                self.purchasedProducts.insert(product)
            }
            await transaction.finish()
        default:
            return
        }
    }
    
    private func listenForTransactions() -> Task < Void, Error > {
        return Task.detached {
            for await result in Transaction.updates {
                await self.handle(transactionVerification: result)
            }
        }
    }
    
    private func updateCurrentEntitlements() async {
        for await result in Transaction.currentEntitlements {
            await self.handle(transactionVerification: result)
        }
    }
}
