//
//  InjectionBundle.swift
//  
//
//  Created by Veronika Medyanik on 02.09.2023.
//

import Foundation

public class InjectionBundle {
    
    public static func load(_ resolver: (DependencyResolver) -> Void) {
        resolver(DependencyResolver.shared)
    }
}
