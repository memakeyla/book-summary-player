//
//  LaunchView.swift
//  BookSummaryPlayer
//
//  Created by Veronika Medyanik on 04.09.2023.
//

import SwiftUI
import StoreKit
import DI

struct LaunchView: View {
    
    @EnvironmentObject private var navigation: RootNavigation.Navigation

    @Inject private var storeViewModel: StoreViewModel

    @State private var bookProduct: BookProduct? = nil
    
    var body: some View {
        ProgressView("Loading")
            .onReceive(storeViewModel.$availableProducts) { products in
                if let bookProduct = products.first {
                    if storeViewModel.isProductPurchased(bookProduct) {
                        withAnimation {
                            navigation.destination = .summaryPlayer
                        }
                     } else {
                         withAnimation(.easeIn(duration: 0.3)) {
                             navigation.destination = .purchase(bookProduct)
                         }
                     }
                }
            }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
