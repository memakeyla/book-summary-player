//
//  Styling.swift
//  BookSummaryPlayer
//
//  Created by Veronika Medyanik on 02.09.2023.
//

import SwiftUI

enum ThemeColor: String {
    case background
}

extension ThemeColor {
    
    var color: Color {
        Color.init(rawValue)
    }
    
    var uiColor: UIColor {
        UIColor(color)
    }
}

extension Color {
    
    static var backgroundColor: Color {
        ThemeColor.background.color
    }
}
