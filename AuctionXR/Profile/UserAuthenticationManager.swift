import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class UserManager: ObservableObject {
    @Published var appState: AppState = .initial
    @Published var userImage: UIImage?
    @Published var userEmail: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var username: String = ""
    @Published var userId: String = ""
    @Published var isImagePickerPresented: Bool = false
    @Published var isAccountSetup = false
   
    
    var userInitial: String {
        username.isEmpty ? "" : String(username.prefix(1)).uppercased()
    }
    
    init() {
        checkUserLoggedIn()
    }
    
    func checkUserLoggedIn() {
        if let currentUser = Auth.auth().currentUser {
            fetchUserDetails(currentUser)
        } else {
            self.appState = .loggedOut
        }
    }
    
    func fetchUserDetails(_ user: FirebaseAuth.User) {
        let db = Firestore.firestore()
        db.collection("users").document(user.uid).getDocument { [weak self] document, error in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching user details: \(error.localizedDescription)")
                // Handle error gracefully
                return
            }
            guard let document = document, document.exists else {
                // User details not found - treat as a new user
                DispatchQueue.main.async {
                    self.handleUserNotFound(userId: user.uid, email: user.email ?? "")
                }
                return
            }
            if let username = document.get("username") as? String {
                DispatchQueue.main.async {
                    self.handleUserFound(userId: user.uid, email: user.email ?? "", username: username)
                }
            } else {
                print("Username not found in user details")
                // Handle missing username gracefully
            }
        }
    }
    
    private func handleUserNotFound(userId: String, email: String) {
        self.userId = userId
        self.userEmail = email
        self.username = ""
        self.userImage = nil
        self.isLoggedIn = true
        self.appState = .loggedIn
    }
    
    private func handleUserFound(userId: String, email: String, username: String) {
        self.userId = userId
        self.userEmail = email
        self.username = username
        self.userImage = nil
        self.isLoggedIn = true
        self.appState = .loggedIn
    }
    
    func updateUsername(_ newUsername: String) {
        self.username = newUsername
       
        
    }
    
    func uploadProfileImage(_ image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5),
              let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(YourError.imageConversionFailed))
            return
        }
        
        let storageRef = Storage.storage().reference().child("profileImages/\(userId).jpg")
        storageRef.putData(imageData, metadata: nil) { [weak self] metadata, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            storageRef.downloadURL { result in
                switch result {
                case .success(let url):
                    completion(.success(url.absoluteString))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func updateUserProfileImagePath(_ imagePath: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let db = Firestore.firestore()
        if let userId = Auth.auth().currentUser?.uid {
            db.collection("users").document(userId).updateData(["profileImagePath": imagePath]) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }
    
    
    private func updateUsernameInFirestore(_ newUsername: String) {
        let db = Firestore.firestore()
        if let userId = Auth.auth().currentUser?.uid {
            db.collection("users").document(userId).updateData(["username": newUsername]) { error in
                if let error = error {
                    print("Error updating username: \(error.localizedDescription)")
                }
            }
        }
    }
    func selectImage() {
        isImagePickerPresented = true
    }
    func saveProfileChanges() {
        // Update username if it has changed
        if !username.isEmpty {
            
            updateUsernameInFirestore(username)
        }
        
        // Upload profile image if it has changed
        if let image = userImage {
            uploadProfileImage(image) { result in
                switch result {
                case .success(let imagePath):
                    // Successfully uploaded image, update profile image path
                    self.updateUserProfileImagePath(imagePath) { result in
                        switch result {
                        case .success:
                            print("Profile image path updated successfully")
                        case .failure(let error):
                            print("Failed to update profile image path: \(error.localizedDescription)")
                        }
                    }
                case .failure(let error):
                    print("Failed to upload profile image: \(error.localizedDescription)")
                }
            }
        }
    }
    func verifyAccountSetup() {
        if let userId = Auth.auth().currentUser?.uid {
            let db = Firestore.firestore()
            db.collection("users").document(userId).getDocument { document, error in
                if let error = error {
                    print("Error verifying account setup:", error.localizedDescription)
                    // Handle the error
                    return
                }
                
                guard let document = document, document.exists else {
                    print("User document does not exist")
                    // Handle the case where the user document does not exist
                    return
                }
                
                if let isAccountSetup = document.data()?["isAccountSetup"] as? Bool {
                    self.isAccountSetup = isAccountSetup
                } else {
                    print("isAccountSetup field not found or invalid")
                    // Handle the case where the isAccountSetup field is missing or invalid
                }
            }
        } else {
            print("No user is currently logged in")
            // Handle the case where no user is logged in
        }
    }

    

    
    enum YourError: Error {
        case imageConversionFailed
    }
}
