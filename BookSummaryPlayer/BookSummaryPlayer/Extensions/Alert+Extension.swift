//
//  Alert+Extension.swift
//  BookSummaryPlayer
//
//  Created by Veronika Medyanik on 02.09.2023.
//

import SwiftUI
import Domain

extension Alert {
    
    static func with(_ info: ErrorMessage, action: (() -> Void)? = {}) -> Alert {
        Alert(
            title: Text(info.title),
            message: Text(info.message ?? ""),
            dismissButton: .default(
                Text("Got it!"),
                action: action
            )
        )
    }
}
