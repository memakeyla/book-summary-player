//
//  BookSummaryPlayerApp.swift
//  BookSummaryPlayer
//
//  Created by Veronika Medyanik on 01.09.2023.
//

import SwiftUI

@main
struct BookSummaryPlayerApp: App {
    
    init() {
        Dependecies.load()
    }
    
    var body: some Scene {
        WindowGroup {
            RootNavigation()
        }
    }
}
