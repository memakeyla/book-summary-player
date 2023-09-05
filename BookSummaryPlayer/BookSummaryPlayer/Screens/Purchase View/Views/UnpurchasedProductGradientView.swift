//
//  UnpurchasedProductGradientView.swift
//  BookSummaryPlayer
//
//  Created by Veronika Medyanik on 04.09.2023.
//

import SwiftUI

struct UnpurchasedProductGradientView: View {
    
    var body: some View {
        VStack(spacing: 0) {
            LinearGradient(
                gradient:
                    Gradient(
                        colors: [.clear, .backgroundColor]
                    ),
                startPoint: .top,
                endPoint: .bottom
            )
            
            Color.backgroundColor
                .frame(height: 250)
        }
    }
}

struct UnpurchasedProductGradientView_Previews: PreviewProvider {
    static var previews: some View {
        UnpurchasedProductGradientView()
    }
}
