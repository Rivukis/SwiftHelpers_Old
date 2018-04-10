//
//  Swinject+Helpers.swift
//
//  Created by Brian Radebaugh on 4/8/18.
//  Copyright © 2018 Brian Radebaugh. All rights reserved.
//

import Foundation
import Swinject

extension Resolver {
    public func forceResolve<Service>(_ serviceType: Service.Type, name: String? = nil) -> Service {
        guard let service = resolve(Service.self, name: name) else {
            fatalError("Could not materialize \(Service.self) with name \(name ?? "nil")")
        }

        return service
    }
}

class ManualResolver {
    static var container = Container()

    public static func finishConstruction<T>(me object: T, as type: T.Type = T.self, name: String? = nil) {
        typealias FactoryType = ((Resolver, T)) -> Any
        _ = container._resolve(name: name, option: nil) { (factory: FactoryType) in
            factory((self.container, object)) as Any
        } as T?
    }
}

extension Container {
    @discardableResult
    public func registerManualConstruction<T>(_ objectType: T.Type, name: String? = nil, injectionHandler: @escaping (Resolver, T) -> Void) -> ServiceEntry<T> {
        let factory = { (r: Resolver, o: T) -> T in
            injectionHandler(r, o)
            return o
        }

        return _register(objectType, factory: factory, name: name, option: nil)
    }
}
