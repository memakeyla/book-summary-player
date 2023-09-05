//
//  Chapter.swift
//  
//
//  Created by Veronika Medyanik on 02.09.2023.
//

import Foundation

public struct Chapter: Equatable {
    
    public let id: String
    public let title: String
    public let fileUrl: URL
    public let duration: Double

    public init(id: String, title: String, fileUrl: URL, duration: Double) {
        self.id = id
        self.title = title
        self.fileUrl = fileUrl
        self.duration = duration
    }
}
