
import SwiftUI

struct UserProfileEditView: View {
    @EnvironmentObject var userData: UserData
    @State private var selectedImage: UIImage?
    @State private var isUploading: Bool = false
    @State private var uploadResultMessage: String?

    var body: some View {
        VStack {
            // Image Picker Button
            Button("Choose Image") {
                // Code to select an image
                // This could be using UIImagePickerController or a custom image picker
            }

            // Image upload button
            Button("Upload Image") {
                guard let image = selectedImage else { return }
                isUploading = true
                userData.uploadProfileImage(image) { result in
                    isUploading = false
                    switch result {
                    case .success(let url):
                        uploadResultMessage = "Image uploaded successfully: \(url)"
                    case .failure(let error):
                        uploadResultMessage = "Image upload failed: \(error.localizedDescription)"
                    }
                }
            }
            .disabled(selectedImage == nil || isUploading)

            // Display upload result message
            if let message = uploadResultMessage {
                Text(message)
            }
        }
    }
}
