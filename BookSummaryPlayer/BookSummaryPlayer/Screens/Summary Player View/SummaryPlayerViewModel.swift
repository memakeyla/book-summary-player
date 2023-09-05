//
//  SummaryPlayerViewModel.swift
//  BookSummaryPlayer
//
//  Created by Veronika Medyanik on 02.09.2023.
//

import Foundation
import Combine
import Domain
import DI

class SummaryPlayerViewModel: BaseViewModel<SummaryPlayerContract.Event, SummaryPlayerContract.State, SummaryPlayerContract.Effect> {
    
    init() {
        super.init(initialState: .idle)
        set(event: .fetchBook)
    }
    
    override func set(event: SummaryPlayerContract.Event) {
        switch event {
        case .fetchBook:
            fetchBookData()
        }
    }
    
    private func fetchBookData() {
        // Fetch book data from a data source or use a real API call here.
        let bookData = createSampleBook()
        uiState = .book(bookData)
    }
    
    private func createSampleBook() -> Book {
        return Book(
            id: UUID().uuidString,
            title: "Oliver Twist",
            coverUrl: URL(string: "https://wordsworth-editions.com/wp-content/uploads/2022/07/9781840228328.jpg")!,
            chapters: [
                .init(
                    id: UUID().uuidString,
                    title: "Treats of the place where Oliver Twist was born and of the circumstances attending his birth.",
                    fileUrl: URL(string: "https://etc.usf.edu/lit2go/audio/mp3/oliver-twist-001-chapter-1-treats-of-the-place-where-oliver-twist-was-born-and-of-the-circumstances-attending-his-birth.932.mp3")!,
                    duration: 409
                ),
                .init(
                    id: UUID().uuidString,
                    title: "Treats of Oliver Twist's growth, education, and board.",
                    fileUrl: URL(string: "https://etc.usf.edu/lit2go/audio/mp3/oliver-twist-002-chapter-2-treats-of-oliver-twists-growth-education-and-board.933.mp3")!,
                    duration: 1384
                ),
                .init(
                    id: UUID().uuidString,
                    title: "Relates how Oliver Twist was very near getting a place which would not have been a sinecure.",
                    fileUrl: URL(string: "https://etc.usf.edu/lit2go/audio/mp3/oliver-twist-003-chapter-3-relates-how-oliver-twist-was-very-near-getting-a-place-which-would-not-have-been-a-sinecure.934.mp3")!,
                    duration: 1084
                )
            ]
        )
    }
}
