//
//  UserStoreProtocol.swift
//  ITSecurityHW
//
//  Created by Kristof Kalai on 2021. 11. 01..
//

import Combine

protocol UserStoreProtocol {
    func getUser() -> AnyPublisher<Author?, Never>
    func getToken() -> AnyPublisher<String?, Never>
}
