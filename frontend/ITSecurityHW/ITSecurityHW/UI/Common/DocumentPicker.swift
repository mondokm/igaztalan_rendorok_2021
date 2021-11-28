//
//  DocumentPicker.swift
//  ITSecurityHW
//
//  Created by Kristof Kalai on 2021. 11. 25..
//

import SwiftUI

struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var base64Content: String

    func makeCoordinator() -> DocumentPickerCoordinator {
        DocumentPickerCoordinator(base64Content: $base64Content)
    }

    func makeUIViewController(
        context: UIViewControllerRepresentableContext<DocumentPicker>) -> UIDocumentPickerViewController {
            let controller = UIDocumentPickerViewController(forOpeningContentTypes: [.item], asCopy: true)
            controller.delegate = context.coordinator
            controller.shouldShowFileExtensions = true
            controller.allowsMultipleSelection = false
            controller.modalPresentationStyle = .fullScreen
            return controller
        }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController,
                                context: UIViewControllerRepresentableContext<DocumentPicker>) { }
}
