//
//  MultiImagePicker.swift
//  AuctionXR
//
//  Created by Abdulwadud Abdulkadir on 2/8/24.
//

import Foundation
import SwiftUI
import PhotosUI

struct MultiImagePicker: View {
    @State private var pickerPresented = false
//    @State var selectedImages: [UIImage] = []
    @Binding var selectedImages: [UIImage]

    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(selectedImages, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .cornerRadius(8)
                    }
                }
            }
            .frame(height: 120)
            .padding()

            Button("Select Images") {
                pickerPresented = true
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .sheet(isPresented: $pickerPresented) {
            PhotoPicker(selectedImages: $selectedImages, limit: 4) // Limit to 4 images
        }
    }
}

struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var selectedImages: [UIImage]
    var limit: Int // Limit the number of selections

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> some UIViewController {
        var config = PHPickerConfiguration()
        config.selectionLimit = limit
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: PhotoPicker

        init(_ parent: PhotoPicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.selectedImages.removeAll()
            
            for result in results {
                result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                    if let image = image as? UIImage {
                        DispatchQueue.main.async {
                            self.parent.selectedImages.append(image)
                        }
                    }
                }
            }

            picker.dismiss(animated: true)
        }
    }
}

struct MultiImagePicker_Previews: PreviewProvider {
    static var previews: some View {
        MultiImagePicker(selectedImages: .constant([]))
    }
}
