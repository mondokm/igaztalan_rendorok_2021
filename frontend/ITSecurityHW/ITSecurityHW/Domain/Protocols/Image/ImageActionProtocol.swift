//
//  ImageActionProtocol.swift
//  ITSecurityHW
//
//  Created by Kristof Kalai on 2021. 11. 01..
//

import Combine

protocol ImageActionProtocol {
    func refreshImages() -> AnyPublisher<Void, Never>
    func upload(name: String, keywords: [String], image: String) -> AnyPublisher<Void, Never>
    func delete(imageId: Int) -> AnyPublisher<Void, Never>
}
