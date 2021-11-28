//
//  ViewModel.swift
//  ITSecurityHW
//
//  Created by Kristof Kalai on 2021. 11. 25..
//

import Combine

typealias Completion = () -> Void

class ViewModel {
    @Injected private(set) var userAction: UserActionProtocol
    @Injected private(set) var userStore: UserStoreProtocol
    @Injected private(set) var searchAction: SearchActionProtocol
    @Injected private(set) var searchStore: SearchStoreProtocol
    @Injected private(set) var imageDetailAction: ImageDetailActionProtocol
    @Injected private(set) var imageDetailStore: ImageDetailStoreProtocol
    @Injected private(set) var imageAction: ImageActionProtocol
    @Injected private(set) var imageStore: ImageStoreProtocol

    @Published var isNotLoading = true

    var cancellables = Set<AnyCancellable>()
}

extension ViewModel {
    func login(name: String, password: String, completion: @escaping () -> Void = { }) {
        isNotLoading = false
        userAction
            .login(name: name, password: password)
            .sink { _ in
                self.isNotLoading = true
                completion()
            }
            .store(in: &cancellables)
    }

    func logOut(completion: @escaping () -> Void = { }) {
        isNotLoading = false
        userAction
            .logOut()
            .sink { _ in
                self.isNotLoading = true
                completion()
            }
            .store(in: &cancellables)
    }

    func signUp(name: String, password: String, completion: @escaping () -> Void = { }) {
        isNotLoading = false
        userAction
            .registration(name: name, password: password)
            .sink { _ in
                self.isNotLoading = true
                completion()
            }
            .store(in: &cancellables)
    }

    func delete(completion: @escaping () -> Void = { }) {
        isNotLoading = false
        userAction
            .delete()
            .sink { _ in
                self.isNotLoading = true
                completion()
            }
            .store(in: &cancellables)
    }

    func search(searchTerm: String, completion: @escaping () -> Void = { }) {
        isNotLoading = false
        searchAction
            .search(searchTerm: searchTerm)
            .sink { _ in
                self.isNotLoading = true
                completion()
            }
            .store(in: &cancellables)
    }

    func comment(imageId: Int, description: String, completion: @escaping () -> Void = { }) {
        isNotLoading = false
        imageDetailAction
            .comment(imageId: imageId, description: description)
            .sink { _ in
                self.isNotLoading = true
                completion()
            }
            .store(in: &cancellables)
    }

    func refreshImageDetails(imageId: Int, completion: @escaping () -> Void = { }) {
        isNotLoading = false
        imageDetailAction
            .refreshImageDetails(imageId: imageId)
            .sink { _ in
                self.isNotLoading = true
                completion()
            }
            .store(in: &cancellables)
    }

    func getFullImage(imageId: Int, completion: @escaping () -> Void = { }) {
        isNotLoading = false
        imageDetailAction
            .getFullImage(imageId: imageId)
            .sink { _ in
                self.isNotLoading = true
                completion()
            }
            .store(in: &cancellables)
    }

    func refreshImages(completion: @escaping () -> Void = { }) {
        isNotLoading = false
        imageAction
            .refreshImages()
            .sink { _ in
                self.isNotLoading = true
                completion()
            }
            .store(in: &cancellables)
    }

    func upload(name: String,
                keywords: [String],
                image: String,
                completion: @escaping () -> Void = { }) {
        isNotLoading = false
        imageAction
            .upload(name: name, keywords: keywords, image: image)
            .sink { _ in
                self.isNotLoading = true
                completion()
            }
            .store(in: &cancellables)
    }

    func delete(imageId: Int, completion: @escaping () -> Void = { }) {
        isNotLoading = false
        imageAction
            .delete(imageId: imageId)
            .sink { _ in
                self.isNotLoading = true
                completion()
            }
            .store(in: &cancellables)
    }
}
