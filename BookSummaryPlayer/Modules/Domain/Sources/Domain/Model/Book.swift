//
//  Book.swift
//  
//
//  Created by Veronika Medyanik on 02.09.2023.
//

import Foundation

public struct Book: Equatable {
    
    public let id: String
    public let title: String
    public let coverUrl: URL
    public let chapters: [Chapter]
    
    public init(id: String, title: String, coverUrl: URL, chapters: [Chapter]) {
        self.id = id
        self.title = title
        self.coverUrl = coverUrl
        self.chapters = chapters
    }
}
