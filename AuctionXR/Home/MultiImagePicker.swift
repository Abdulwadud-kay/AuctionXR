import SwiftUI
import PhotosUI

struct PHPickerViewControllerWrapper: UIViewControllerRepresentable {
    @Binding var selectedImages: [UIImage]
    @Binding var isPresented: Bool

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.selectionLimit = 4
        config.filter = .images

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: PHPickerViewControllerWrapper

        init(_ parent: PHPickerViewControllerWrapper) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            for result in results {
                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                        if let image = image as? UIImage {
                            DispatchQueue.main.async {
                                if !self.parent.selectedImages.contains(image) {
                                    self.parent.selectedImages.append(image)
                                }
                            }
                        }
                    }
                }
            }
            // Dismiss the sheet view when finished picking
            parent.isPresented = false
        }

        func pickerDidCancel(_ picker: PHPickerViewController) {
            // Dismiss the sheet view when canceled
            parent.isPresented = false
        }
    }

}
