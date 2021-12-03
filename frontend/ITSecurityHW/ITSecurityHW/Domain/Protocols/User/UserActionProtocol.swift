//
//  UserActionProtocol.swift
//  ITSecurityHW
//
//  Created by Kristof Kalai on 2021. 11. 01..
//

import Combine

protocol UserActionProtocol {
    func login(name: String, password: String) -> AnyPublisher<Void, Never>
    func registration(name: String, password: String) -> AnyPublisher<Void, Never>
    func delete() -> AnyPublisher<Void, Never>
    func logOut() -> AnyPublisher<Void, Never>
    func change(id: Int, userName: String, password: String) -> AnyPublisher<Void, Never>
    func delete(id: Int) -> AnyPublisher<Void, Never>
}
