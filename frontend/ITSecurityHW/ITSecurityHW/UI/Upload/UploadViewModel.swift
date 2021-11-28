//
//  UploadViewModel.swift
//  ITSecurityHW
//
//  Created by Kristof Kalai on 2021. 11. 01..
//

import Combine

final class UploadViewModel: ViewModel, ObservableObject {
    @Injected var imageService: ImageActionProtocol
}
