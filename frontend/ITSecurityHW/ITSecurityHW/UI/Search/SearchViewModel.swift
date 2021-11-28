//
//  SearchViewModel.swift
//  ITSecurityHW
//
//  Created by Kristof Kalai on 2021. 11. 01..
//

import Combine

final class SearchViewModel: ViewModel, ObservableObject {
    @Injected var searchService: SearchActionProtocol
    @Published var images = [Caff]()

    override init() {
        super.init()
        searchStore.getImages()
            .sink { [weak self] in self?.images = $0 }
            .store(in: &cancellables)
    }
}
