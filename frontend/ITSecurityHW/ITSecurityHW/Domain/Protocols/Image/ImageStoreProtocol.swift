//
//  ImageStoreProtocol.swift
//  ITSecurityHW
//
//  Created by Kristof Kalai on 2021. 11. 01..
//

import Combine

protocol ImageStoreProtocol {
    func getImages() -> AnyPublisher<[CaffWithoutComments], Never>
}
