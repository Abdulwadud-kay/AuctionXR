import FirebaseAuth
import FirebaseFirestore
import Combine

class UserAuthenticationManager: ObservableObject {
    @Published var appState: AppState = .initial
    var userData: UserData = UserData()
    
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
            if let document = document, document.exists {
                let username = document.get("username") as? String ?? "Unknown"
                DispatchQueue.main.async {
                    // Include the user's ID in updateUserDetails
                    self.userData.updateUserDetails(userId: user.uid, email: user.email ?? "", username: username)
                    // Ensure userImage is nil for new users
                    self.userData.userImage = nil
                    self.appState = .loggedIn
                }
            } else {
                // User details not found - treat as a new user
                DispatchQueue.main.async {
                    // Include the user's ID in updateUserDetails
                    self.userData.updateUserDetails(userId: user.uid, email: user.email ?? "", username: "")
                    self.userData.userImage = nil
                    self.appState = .loggedIn
                }
            }
        }
    }
}
