//
//  InjectObject.swift
//  
//
//  Created by Veronika Medyanik on 02.09.2023.
//

import SwiftUI

@propertyWrapper
public struct InjectObject<T>: DynamicProperty where T: ObservableObject {
    
    public var wrappedValue: T {
        get { value }
        set { value = newValue}
    }
    
    @ObservedObject
    private var value: T
    
    public init() {
        value = DependencyResolver.shared.resolve()
    }
}
