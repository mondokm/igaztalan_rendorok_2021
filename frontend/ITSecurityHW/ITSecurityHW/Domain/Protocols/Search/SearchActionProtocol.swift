//
//  SearchActionProtocol.swift
//  ITSecurityHW
//
//  Created by Kristof Kalai on 2021. 11. 01..
//

import Combine

protocol SearchActionProtocol {
    func search(searchTerm: String) -> AnyPublisher<Void, Never>
}
