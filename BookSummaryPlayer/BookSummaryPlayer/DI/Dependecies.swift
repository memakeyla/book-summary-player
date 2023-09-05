//
//  Dependecies.swift
//  BookSummaryPlayer
//
//  Created by Veronika Medyanik on 02.09.2023.
//

import Foundation
import DI
import Domain

struct Dependecies {
    
    static func load() {
        InjectionBundle.load { resolver in
            /// Common
            resolver.single { AudioPlayerViewModel() }
            resolver.single { StoreViewModel() }

            /// View Models
            resolver.factory { SummaryPlayerViewModel() }
        }
    }
}
