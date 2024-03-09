import FirebaseAuth
import FirebaseFirestore
import Combine

class UserAuthenticationManager: ObservableObject {
    @Published var appState: AppState = .initial
    var userData: UserData = UserData()
    private var cancellables: Set<AnyCancellable> = []

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
        userData.updateUserDetails(userId: userId, email: email, username: "")
        userData.userImage = nil
        appState = .loggedIn
    }

    private func handleUserFound(userId: String, email: String, username: String) {
        userData.updateUserDetails(userId: userId, email: email, username: username)
        userData.userImage = nil
        appState = .loggedIn
    }
}
