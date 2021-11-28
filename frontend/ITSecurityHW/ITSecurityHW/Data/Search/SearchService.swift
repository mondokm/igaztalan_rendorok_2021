//
//  SearchService.swift
//  ITSecurityHW
//
//  Created by Kristof Kalai on 2021. 11. 01..
//

import Combine

final class SearchService {
    @Injected private var searchCache: SearchCache
}

extension SearchService: Service { }

extension SearchService: SearchActionProtocol {
    func search(searchTerm: String) -> AnyPublisher<Void, Never> {
        Future { [weak self] completable in
            DefaultAPI
                .caffFindGetWithRequestBuilder(keyword: searchTerm)
                .addToken()
                .execute { data, error in
                    if let data = data?.body {
                        self?.searchCache.save(item: data)
                        Self.log(data.caffs.first?.title)
                    } else {
                        Self.log(error)
                    }
                    completable(.success(()))
                }
        }.eraseToAnyPublisher()
    }
}

extension SearchService: SearchStoreProtocol {
    func getImages() -> AnyPublisher<[Caff], Never> {
        searchCache.value().compactMap { $0?.caffs }.eraseToAnyPublisher()
    }
}
