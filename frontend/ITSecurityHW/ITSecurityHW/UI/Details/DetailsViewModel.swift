//
//  DetailsViewModel.swift
//  ITSecurityHW
//
//  Created by Kristof Kalai on 2021. 11. 01..
//

import Combine

final class DetailsViewModel: ViewModel, ObservableObject {
    @Published var image = CaffWithoutComments(title: "",
                                               _id: 0,
                                               creatorId: 0,
                                               keywords: [],
                                               base64Preview: "",
                                               comments: [])

    override init() {
        super.init()
        imageDetailStore.getImageDetail()
            .sink { [weak self] in self?.image = $0 }
            .store(in: &cancellables)
    }
}
