//
//  GalleryViewModel.swift
//  ITSecurityHW
//
//  Created by Kristof Kalai on 2021. 11. 01..
//

import Combine

final class GalleryViewModel: ViewModel, ObservableObject {
    @Injected var imageService: ImageActionProtocol
    @Published var images: [CaffWithoutComments] = [CaffWithoutComments]()

    override init() {
        super.init()

        imageStore.getImages()
            .sink { [weak self] images in
                self?.images = images
            }
            .store(in: &cancellables)
    }
}
