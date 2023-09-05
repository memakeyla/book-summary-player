//
//  ErrorMessage.swift
//  
//
//  Created by Veronika Medyanik on 02.09.2023.
//

import Foundation

public struct ErrorMessage: Equatable, Hashable {
    
    public var title: String
    public var message: String?
    
    public init(title: String, message: String? = nil) {
        self.title = title
        self.message = message
    }
    
    public init(error: Error) {
        self.title = "Something went wrong :("
        self.message = error.localizedDescription
    }
}

extension ErrorMessage: Identifiable {
    
    public var id: Int {
        return hashValue
    }
}
