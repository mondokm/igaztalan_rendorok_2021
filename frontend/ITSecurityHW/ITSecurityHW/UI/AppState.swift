//
//  AppState.swift
//  Consultation
//
//  Created by Geza Konczos on 2021. 11. 17..
//

import Foundation
import Combine

class AppState: ObservableObject {
    private lazy var userStore: UserStoreProtocol = UserService()
    @Published var hasAuthenticated = false
    var cancellables = Set<AnyCancellable>()

    init() {
        DispatchQueue.main.async { [self] in
            userStore.getUser().sink { [self] user in
                self.hasAuthenticated = user != nil
            }
            .store(in: &cancellables)
            userStore.getToken().sink { [self] user in
                self.hasAuthenticated = user != nil
            }
            .store(in: &cancellables)
        }
    }
}
