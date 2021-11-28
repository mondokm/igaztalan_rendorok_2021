//
//  Injected.swift
//  ITSecurityHW
//
//  Created by Kristof Kalai on 2021. 11. 01..
//

@propertyWrapper struct Injected<Service> {
    private var service: Service

    init() {
        self.service = DependencyInjector.resolve(Service.self)
    }

    var wrappedValue: Service {
        get { service }
        mutating set { service = newValue }
    }

    var projectedValue: Injected<Service> {
        get { self }
        mutating set { self = newValue }
    }
}
