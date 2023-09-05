//
//  DependencyResolver.swift
//  
//
//  Created by Veronika Medyanik on 02.09.2023.
//

import Foundation

public class DependencyResolver {
    
    private typealias FactoryCallback = () -> Any
    
    static let shared = DependencyResolver()
    
    private var singles = [String: Any]()
    private var factories = [String: FactoryCallback]()
    
    public func single<T>(_ resolver: () -> T) {
        singles[String(describing: T.self)] = resolver()
    }
    
    public func factory<T>(_ resolver: @escaping () -> T) {
        factories[String(describing: T.self)] = resolver
    }
    
    public func resolve<T>() -> T {
        let key = String(describing: T.self)
        
        if let single = singles[key] as? T {
            return single
        }
        
        if let factory = factories[key]?() as? T {
            return factory
        }
        
        fatalError("Dependency \(key) no registered")
    }
}
