//
//  UserAuthenticationManager.swift
//  AuctionX
//
//  Created by Abdulwadud Abdulkadir on 1/27/24.
//


// UserAuthenticationManager.swift

import FirebaseAuth
import FirebaseFirestore
import Combine

class UserAuthenticationManager: ObservableObject {
    @Published var appState: AppState = .initial
    @Published var isLoading: Bool = false
    var userData: UserData = UserData()
    
    init() {
            checkUserLoggedIn()
        }
    
    func checkUserLoggedIn() {
        if Auth.auth().currentUser != nil {
            self.appState = .loggedIn
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
                self.userData.updateUserDetails(email: user.email ?? "", username: username)
                self.appState = .loggedIn
                
            } else {
                print("User details not found: \(error?.localizedDescription ?? "")")
                self.appState = .loggedOut
            }
        }
    }
}
