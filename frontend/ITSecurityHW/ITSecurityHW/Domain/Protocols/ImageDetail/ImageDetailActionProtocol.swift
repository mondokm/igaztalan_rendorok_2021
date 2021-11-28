//
//  ImageDetailActionProtocol.swift
//  ITSecurityHW
//
//  Created by Kristof Kalai on 2021. 11. 01..
//

import Combine

protocol ImageDetailActionProtocol {
    func refreshImageDetails(imageId: Int) -> AnyPublisher<Void, Never>
    func getFullImage(imageId: Int) -> AnyPublisher<Void, Never>
    func comment(imageId: Int, description: String) -> AnyPublisher<Void, Never>
}
