//
//  SummaryPlayerContract.swift
//  BookSummaryPlayer
//
//  Created by Veronika Medyanik on 02.09.2023.
//

import Foundation
import Combine
import Domain

struct SummaryPlayerContract {
    
    enum Event: UiEvent {
        case fetchBook
    }
    
    enum State: UiState, Equatable {
        case idle
        case book(Book)
        case failure(ErrorMessage)
    }
    
    enum Effect: UiEffect { }
}
