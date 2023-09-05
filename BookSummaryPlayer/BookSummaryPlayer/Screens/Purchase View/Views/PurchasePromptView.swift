//
//  PurchasePromptView.swift
//  BookSummaryPlayer
//
//  Created by Veronika Medyanik on 04.09.2023.
//

import SwiftUI

struct PurchasePromptView: View {
    
    @State var price: String
    
    var onPurchaseAttempt: () -> Void
    
    var body: some View {
        ZStack {
            UnpurchasedProductGradientView()

            VStack(spacing: 32) {
                Spacer()
                
                VStack(alignment: .center, spacing: 24) {
                    titleText
                    subtitleText
                }
                
                buyButton
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 64)
        }
    }
    
    var titleText: some View {
        Text("Unlock learning")
            .font(.largeTitle)
            .bold()
    }
    
    var subtitleText: some View {
        Text("Grow on the go by listening and reading the world`s best ideas")
            .font(.title3)
            .multilineTextAlignment(.center)
    }
    
    @ViewBuilder
    var buyButton: some View {
        Button {
            onPurchaseAttempt()
        } label: {
            Text("Start Listening \(price)")
                .bold()
                .foregroundColor(.white)
                .padding()
        }
        .frame(maxWidth: .infinity)
        .background(Color.accentColor.cornerRadius(8))
    }
}

struct PurchasePromptView_Previews: PreviewProvider {
    static var previews: some View {
        PurchasePromptView(
            price: "0.99",
            onPurchaseAttempt: { }
        )
    }
}
