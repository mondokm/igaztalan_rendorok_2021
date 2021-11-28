//
//  DocumentPickerCoordinator.swift
//  ITSecurityHW
//
//  Created by Kristof Kalai on 2021. 11. 26..
//

import SwiftUI

final class DocumentPickerCoordinator: NSObject {
    @Binding var base64Content: String

    init(base64Content: Binding<String>) {
        _base64Content = base64Content
    }
}

extension DocumentPickerCoordinator: UIDocumentPickerDelegate, UINavigationControllerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first,
              let base64Content = try? Data(contentsOf: url).base64EncodedString(),
              url.pathExtension.lowercased() == "caff" else { return }
        self.base64Content = base64Content
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        documentPicker(controller, didPickDocumentsAt: [url])
    }
}
