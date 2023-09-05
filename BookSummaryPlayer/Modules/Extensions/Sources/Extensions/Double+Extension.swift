//
//  Double+Extension.swift
//  
//
//  Created by Veronika Medyanik on 02.09.2023.
//

import Foundation

public extension Double {
    
    var formattedTime: String {
        let minutes = Int(self / 60)
        let seconds = Int(self) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    var formattedSpeedRate: String {
        return String(format: "x%.1f", self)
    }
}
