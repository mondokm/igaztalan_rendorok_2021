//
//  ImageDetailStoreProtocol.swift
//  ITSecurityHW
//
//  Created by Kristof Kalai on 2021. 11. 01..
//

import Combine

protocol ImageDetailStoreProtocol {
    func getImageDetail() -> AnyPublisher<CaffWithoutComments, Never>
    func getFullImage() -> AnyPublisher<FullCaff, Never>
}
