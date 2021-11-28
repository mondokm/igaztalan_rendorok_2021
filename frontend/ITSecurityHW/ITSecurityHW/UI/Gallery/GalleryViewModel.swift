//
//  GalleryViewModel.swift
//  ITSecurityHW
//
//  Created by Kristof Kalai on 2021. 11. 01..
//

import Combine

final class GalleryViewModel: ViewModel, ObservableObject {
    @Published var images = [CaffWithoutComments]()

    override init() {
        super.init()
        imageStore.getImages()
            .sink { [weak self] in self?.images = $0 }
            .store(in: &cancellables)
    }
}
