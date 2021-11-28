//
//  LoginViewModel.swift
//  ITSecurityHW
//
//  Created by Kristof Kalai on 2021. 11. 01..
//

import Combine
import SwiftUI

final class LoginViewModel: ViewModel, ObservableObject {
    @Published var author: Author?
    @Published var image: String?

    override init() {
        super.init()
        userStore
            .getUser()
            .sink { [weak self] in self?.author = $0 }
            .store(in: &cancellables)

        imageDetailStore.getImageDetail()
            .sink { print($0.title.first as Any) }
            .store(in: &cancellables)

        imageStore.getImages()
            .sink { [weak self] images in
                if let self = self, let id = images.first?._id {
                    self.image = images.first?.base64Preview
                    self.refreshImageDetails(imageId: id)
                    self.getFullImage(imageId: id) {
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                            self.delete(imageId: id) {
//                                self.delete()
//                            }
//                        }
                    }
                    self.comment(imageId: id, description: "random comment: \(UUID().uuidString)")
                }
            }
            .store(in: &cancellables)
    }
}
