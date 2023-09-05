//
//  Inject.swift
//  
//
//  Created by Veronika Medyanik on 02.09.2023.
//

import Foundation

@propertyWrapper
public struct Inject<T> {
    
    public var wrappedValue: T {
        get { value }
        set { value = newValue }
    }
    
    private var value: T
    
    public init() {
        value = DependencyResolver.shared.resolve()
    }
}
