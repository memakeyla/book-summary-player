//
//  RootNavigation.swift
//  BookSummaryPlayer
//
//  Created by Veronika Medyanik on 04.09.2023.
//

import SwiftUI

struct RootNavigation: View {
    
    class Navigation: ObservableObject {
        @Published var destination: NavigationDestination = .launch
    }
    
    @StateObject private var navigation = Navigation()
    
    var body: some View {
        Group {
            switch navigation.destination {
            case .launch:
                LaunchView()
            case .purchase(let bookProduct):
                PurchaseView(
                    product: bookProduct
                )
            case .summaryPlayer:
                SummaryPlayerView()
            }
        }
        .environmentObject(navigation)
    }
}
