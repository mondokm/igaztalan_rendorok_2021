//
//  Cache.swift
//  ITSecurityHW
//
//  Created by Kristof Kalai on 2021. 11. 01..
//

import Combine

class Cache<Item> {
    private let cache = CurrentValueSubject<Item?, Never>(nil)
}

extension Cache {
    var immediateValue: Item? {
        cache.value
    }

    func value() -> AnyPublisher<Item?, Never> {
        cache.eraseToAnyPublisher()
    }

    func clear() {
        cache.send(nil)
    }

    func saveWithPublisher(item: Item) -> AnyPublisher<Void, Never> {
        Future { [weak cache] in
            cache?.send(item)
            $0(.success(()))
        }.eraseToAnyPublisher()
    }

    func save(item: Item) {
        cache.send(item)
    }
}
