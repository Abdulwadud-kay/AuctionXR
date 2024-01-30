import Foundation
import SwiftUI
import UIKit // Import UIKit to use UIImage
import FirebaseStorage

class UserData: ObservableObject {
    @Published var userImage: UIImage? // This will be nil unless you have a method to set it
    @Published var userEmail: String = ""
    @Published var isLoggedIn: Bool = true
    @Published var username: String = ""

    
    enum YourError: Error {
        case imageConversionFailed
        // Add more custom error cases as needed
    }
    // Computed property for userInitial without @Published
    var userInitial: String {
        userEmail.isEmpty ? "" : String(userEmail.prefix(1)).uppercased()
    }

    func updateUserDetails(email: String, username: String) {
        self.userEmail = email
        self.username = username
    }

    func updateLoginState(isLoggedIn: Bool) {
        self.isLoggedIn = isLoggedIn
    }

    func uploadProfileImage(_ image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {


        // Convert image to Data
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(.failure(YourError.imageConversionFailed))
            return
        }

        // Define a reference to Firebase Storage location
        let storageRef = Storage.storage().reference().child("profileImages/\(self.userEmail).jpg")

        // Upload the image
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            // Retrieve the download URL
            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                } else if let url = url {
                    completion(.success(url.absoluteString))
                }
            }
        }
    }
}
