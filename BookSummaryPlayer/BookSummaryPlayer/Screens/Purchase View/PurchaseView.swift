//
//  PurchaseView.swift
//  BookSummaryPlayer
//
//  Created by Veronika Medyanik on 04.09.2023.
//

import SwiftUI
import Domain
import DI

struct PurchaseView: View {
    
    @EnvironmentObject private var navigation: RootNavigation.Navigation

    @Inject private var storeViewModel: StoreViewModel
    
    @State private var errorMessage: ErrorMessage?
    
    @State var product: BookProduct
    
    var body: some View {
        ZStack {
            SummaryPlayerView()
                .disabled(true)
            
            PurchasePromptView(
                price: product.displayPrice,
                onPurchaseAttempt: {
                    purchaseBook()
                }
            )
        }
        .onReceive(storeViewModel.$purchaseError) { errorMessage in
            self.errorMessage = errorMessage
        }
        .onReceive(storeViewModel.$purchasedProducts) { products in
            if products.contains(product) {
                withAnimation(.easeOut(duration: 0.5)) {
                    navigation.destination = .summaryPlayer
                }
            }
        }
        .alert(item: $errorMessage) {
            Alert.with($0)
        }
    }
    
    private func purchaseBook() {
        Task {
            try await storeViewModel.purchase(product)
        }
    }
}
