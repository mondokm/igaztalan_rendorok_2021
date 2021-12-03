//
//  UserService.swift
//  ITSecurityHW
//
//  Created by Kristof Kalai on 2021. 11. 01..
//

import Combine

final class UserService {
    @Injected private var userCache: UserCache
    @Injected private var tokenCache: TokenCache
}

extension UserService: Service { }

extension UserService: UserActionProtocol {
    func logOut() -> AnyPublisher<Void, Never> {
        Future { completable in
            self.userCache.clear()
            self.tokenCache.clear()
            AppData.shared.token = nil
            AppData.shared.isAdmin = nil
            AppData.shared.id = nil
            completable(.success(()))
        }.eraseToAnyPublisher()
    }

    func change(id: Int, userName: String, password: String) -> AnyPublisher<Void, Never> {
        Future { completable in
            DefaultAPI.userIdPutWithRequestBuilder(_id: id, user: RegistrationModel(name: userName, password: password))
                .addToken()
                .execute { data, error in
                    if let data = data {
                        Self.log(data)
                    } else {
                        Self.log(error)
                    }
                    completable(.success(()))
                }
        }.eraseToAnyPublisher()
    }

    func delete(id: Int) -> AnyPublisher<Void, Never> {
        Future { completable in
            DefaultAPI.userIdDeleteWithRequestBuilder(_id: id)
                .addToken()
                .execute { data, error in
                    if let data = data {
                        Self.log(data)
                    } else {
                        Self.log(error)
                    }
                    completable(.success(()))
                }
        }.eraseToAnyPublisher()
    }

    func login(name: String, password: String) -> AnyPublisher<Void, Never> {
        Future { completable in
            DefaultAPI.loginPost(user: LoginRegistrationBody(password: password, name: name)) { data, error in
                if let data = data {
                    AppData.shared.token = data.token
                    AppData.shared.isAdmin = data.isAdmin == 1
                    AppData.shared.id = data.userId
                    self.tokenCache.save(item: data.token)
                    Self.log(data)
                } else {
                    Self.log(error)
                }
                completable(.success(()))
            }
        }.eraseToAnyPublisher()
    }

    func registration(name: String, password: String) -> AnyPublisher<Void, Never> {
        Future { [weak self] completable in
            DefaultAPI.userSignUpPost(user: LoginRegistrationBody(password: password, name: name)) { data, error in
                if let data = data {
                    self?.userCache.save(item: data)
                    AppData.shared.id = data._id
                    Self.log(data)

                    DefaultAPI.loginPost(user: LoginRegistrationBody(password: password, name: name)) { data, error in
                        if let data = data {
                            AppData.shared.token = data.token
                            AppData.shared.isAdmin = data.isAdmin == 1
                            AppData.shared.id = data.userId
                            self?.tokenCache.save(item: data.token)
                            Self.log(data)
                        } else {
                            Self.log(error)
                        }
                        completable(.success(()))
                    }

                } else {
                    Self.log(error)
                    completable(.success(()))
                }

            }
        }.eraseToAnyPublisher()
    }

    func delete() -> AnyPublisher<Void, Never> {
        Future { completable in
            DefaultAPI.userIdDeleteWithRequestBuilder(_id: AppData.shared.id ?? -1)
                .addToken()
                .execute { data, error in
                    if let data = data {
                        Self.log(data)
                    } else {
                        Self.log(error)
                    }
                    completable(.success(()))
                }
        }.eraseToAnyPublisher()
    }
}

extension UserService: UserStoreProtocol {
    func getToken() -> AnyPublisher<String?, Never> {
        tokenCache.value().eraseToAnyPublisher()
    }

    func getUser() -> AnyPublisher<Author?, Never> {
        userCache.value().eraseToAnyPublisher()
    }
}
