//
//  BaseViewModel.swift
//  BookSummaryPlayer
//
//  Created by Veronika Medyanik on 02.09.2023.
//

import Foundation
import SwiftUI
import Combine

class BaseViewModel<Event: UiEvent, State: UiState, Effect: UiEffect>: ObservableObject {
    
    @Published
    var uiState: State
    var effect: AnyPublisher<Effect, Never> {
        effectSubject.eraseToAnyPublisher()
    }
    
    private let eventSubject = PassthroughSubject<Event, Never>()
    private let effectSubject = PassthroughSubject<Effect, Never>()
    
    init(initialState: State) {
        uiState = initialState
    }
    
    func set(event: Event) {
        fatalError("Implement in child class")
    }
    
    func set(effect: Effect) {
        effectSubject.send(effect)
    }
}
