//
//  VideoPicker.swift
//  AuctionXR
//
//  Created by Abdulwadud Abdulkadir on 2/9/24.
//

import Foundation
import SwiftUI
struct VideoPicker: UIViewControllerRepresentable {
    @Binding var selectedVideoURL: URL?
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.mediaTypes = ["public.movie"]
        picker.videoQuality = .typeHigh
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: VideoPicker

        init(_ parent: VideoPicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let videoURL = info[.mediaURL] as? URL {
                parent.selectedVideoURL = videoURL
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

