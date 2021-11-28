//
//  SearchStoreProtocol.swift
//  ITSecurityHW
//
//  Created by Kristof Kalai on 2021. 11. 01..
//

import Combine

protocol SearchStoreProtocol {
    func getImages() -> AnyPublisher<[Caff], Never>
}
