

import Foundation
import SwiftUI
import UIKit // Import UIKit to use UIImage

class UserData: ObservableObject {
    @Published var userImage: UIImage? // This will be nil unless you have a method to set it
    @Published var userEmail: String = ""
    @Published var isLoggedIn: Bool = true
    @Published var username: String = ""
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

}

