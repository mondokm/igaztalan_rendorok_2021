//
//  Image+Extensions.swift
//  ITSecurityHW
//
//  Created by Kristof Kalai on 2021. 11. 26..
//

import SwiftUI
import Kingfisher

struct AnimatedImage: UIViewRepresentable {
    @Binding var base64: String?
    @State private var previousBase64 = ""
    private let imageView = AnimatedImageView()

    func makeUIView(context: Context) -> AnimatedImageView {
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }

    func updateUIView(_ uiView: AnimatedImageView, context: Context) {
        if let base64 = base64, previousBase64 != base64 {
            uiView.kf.setImage(with: .provider(Base64ImageDataProvider(base64String: base64,
                                                                       cacheKey: UUID().uuidString)))
            DispatchQueue.main.async {
                previousBase64 = base64
            }
        }
    }
}

struct AnimatedImage2: UIViewRepresentable {
    @Binding var base64: String
    @State private var previousBase64 = ""
    private let imageView = AnimatedImageView()

    func makeUIView(context: Context) -> AnimatedImageView {
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }

    func updateUIView(_ uiView: AnimatedImageView, context: Context) {
        if previousBase64 != base64 {
            uiView.kf.setImage(with: .provider(Base64ImageDataProvider(base64String: base64,
                                                                       cacheKey: UUID().uuidString)))
            DispatchQueue.main.async {
                previousBase64 = base64
            }
        }
    }
}
