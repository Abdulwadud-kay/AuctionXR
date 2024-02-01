import Foundation
import SwiftUI
import UIKit // Import UIKit to use UIImage
import FirebaseStorage
import FirebaseAuth


class UserData: ObservableObject {
    @Published var userImage: UIImage?
    @Published var userEmail: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var username: String = ""

    var userInitial: String {
        username.isEmpty ? "" : String(username.prefix(1)).uppercased()
    }

    func updateUserDetails(email: String, username: String) {
        self.userEmail = email
        self.username = username
    }

    func updateLoginState(isLoggedIn: Bool) {
        self.isLoggedIn = isLoggedIn
    }

    func uploadProfileImage(_ image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5),
              let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(YourError.imageConversionFailed))
            return
        }

        let storageRef = Storage.storage().reference().child("profileImages/\(userId).jpg")
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                } else if let url = url {
                    completion(.success(url.absoluteString))
                }
            }
        }
    }
    enum YourError: Error {
            case imageConversionFailed
        }
}
