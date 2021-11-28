//
//  ImageService.swift
//  ITSecurityHW
//
//  Created by Kristof Kalai on 2021. 11. 01..
//

import Combine

final class ImageService {
    @Injected private var imageCache: ImageCache
}

extension ImageService: Service { }

extension ImageService: ImageActionProtocol {
    func refreshImages() -> AnyPublisher<Void, Never> {
        Future { [weak self] completable in
            DefaultAPI
                .caffDescriptorGetWithRequestBuilder()
                .addToken()
                .execute { data, error in
                    if let data = data?.body?.caffs {
                        self?.imageCache.save(item: data)
                        Self.log(data.count)
                    } else {
                        Self.log(error)
                    }
                    completable(.success(()))
                }
        }.eraseToAnyPublisher()
    }

    func upload(name: String, keywords: [String], image: String) -> AnyPublisher<Void, Never> {
        Future { completable in
            DefaultAPI
                .caffUploadPostWithRequestBuilder(user: CaffBody(title: name,
                                                                 creatorId: AppData.shared.id ?? -1,
                                                                 keywords: keywords,
                                                                 base64Caff: image))
                .addToken()
                .execute { data, error in
                    if let data = data?.body {
                        Self.log(data.title)
                    } else {
                        Self.log(error)
                    }
                    completable(.success(()))
                }
        }.eraseToAnyPublisher()
    }

    func delete(imageId: Int) -> AnyPublisher<Void, Never> {
        Future { completable in
            DefaultAPI
                .caffIdDeleteWithRequestBuilder(_id: imageId)
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

extension ImageService: ImageStoreProtocol {
    func getImages() -> AnyPublisher<[CaffWithoutComments], Never> {
        imageCache.value().compactMap { $0 }.eraseToAnyPublisher()
    }
}
