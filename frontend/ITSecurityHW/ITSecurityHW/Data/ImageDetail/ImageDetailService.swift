//
//  ImageDetailService.swift
//  ITSecurityHW
//
//  Created by Kristof Kalai on 2021. 11. 01..
//

import Combine
import Foundation

final class ImageDetailService {
    @Injected private var imageDetailCache: ImageDetailCache
    @Injected private var fullImageCache: FullImageCache
}

extension ImageDetailService: Service { }

extension ImageDetailService: ImageDetailActionProtocol {
    func refreshImageDetails(imageId: Int) -> AnyPublisher<Void, Never> {
        Future { [weak self] completable in
            DefaultAPI
                .caffDescriptorIdGetWithRequestBuilder(_id: imageId)
                .addToken()
                .execute { data, error in
                    if let data = data?.body {
                        self?.imageDetailCache.save(item: data)
                        Self.log(data.title)
                    } else {
                        Self.log(error)
                    }
                    completable(.success(()))
                }
        }.eraseToAnyPublisher()
    }

    func getFullImage(imageId: Int) -> AnyPublisher<Void, Never> {
        Future { [weak self] completable in
            DefaultAPI
                .caffFullIdGetWithRequestBuilder(_id: imageId)
                .addToken()
                .execute { data, error in
                    if let data = data?.body {
                        self?.fullImageCache.save(item: data)
                        Self.log(data.base64Caff.first as Any)
                    } else {
                        Self.log(error)
                    }
                    completable(.success(()))
                }
        }.eraseToAnyPublisher()
    }

    func comment(imageId: Int, description: String) -> AnyPublisher<Void, Never> {
        Future { completable in
            DefaultAPI
                .caffCommentPostWithRequestBuilder(user: CommentRequest(caffId: imageId,
                                                                        authorId: AppData.shared.id ?? -1,
                                                                        message: description,
                                                                        timestamp: Date().timeIntervalSince1970))
                .addToken()
                .execute { data, error in
                    if let data = data?.body {
                        Self.log(data)
                    } else {
                        Self.log(error)
                    }
                    completable(.success(()))
                }
        }.eraseToAnyPublisher()
    }
}

extension ImageDetailService: ImageDetailStoreProtocol {
    func getImageDetail() -> AnyPublisher<CaffWithoutComments, Never> {
        imageDetailCache.value().compactMap { $0 }.eraseToAnyPublisher()
    }

    func getFullImage() -> AnyPublisher<FullCaff, Never> {
        fullImageCache.value().compactMap { $0 }.eraseToAnyPublisher()
    }
}
