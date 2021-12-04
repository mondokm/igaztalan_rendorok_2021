//
//  DetailsViewModel.swift
//  ITSecurityHW
//
//  Created by Kristof Kalai on 2021. 11. 01..
//

import Combine
import UIKit

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
        imageDetailStore.getFullImage()
            .sink { [weak self] in
                guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                    print("user directory not found")
                    return
                }
                let url = dir.appendingPathComponent("\(self?.image.title ?? UUID().uuidString).caff")
                try? Data(base64Encoded: $0.base64Caff)?.write(to: url, options: .atomic)
                let activityViewController = UIActivityViewController(
                    activityItems: [url],
                    applicationActivities: nil)
                UIApplication.shared.windows.first?.rootViewController?.present(activityViewController,
                                                                                animated: true,
                                                                                completion: nil)
            }
            .store(in: &cancellables)
    }
}
