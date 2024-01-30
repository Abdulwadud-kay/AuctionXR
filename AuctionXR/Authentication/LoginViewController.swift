import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct LoginViewController: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @Binding var appState: AppState
    @EnvironmentObject var userAuthManager: UserAuthenticationManager
    
    let backgroundColor = Color(hex: "f4e9dc")
    let buttonColor = Color(hex: "dbb88e")
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 15) {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                if showError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Button("Login") {
                    loginUser()
                }
                .padding(8)
                .background(buttonColor)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(.horizontal)
                
                NavigationLink(destination: RegisterViewController(appState: $appState).environmentObject(userAuthManager)) {
                    Text("Don't have an account? Register here")
                        .foregroundColor(buttonColor)
                        .underline()
                }
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(backgroundColor)
            .edgesIgnoringSafeArea(.all)
        }
    }
    
    func loginUser() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let user = authResult?.user {
                self.fetchUserDetailsAndLogin(user)
            } else if let error = error {
                DispatchQueue.main.async {
                    self.showError = true
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    private func fetchUserDetailsAndLogin(_ user: FirebaseAuth.User) {
        let db = Firestore.firestore()
        db.collection("users").document(user.uid).getDocument { document, error in
            if let document = document, document.exists {
                let username = document.get("username") as? String ?? "Unknown"
                DispatchQueue.main.async {
                    self.userAuthManager.userData.updateUserDetails(email: user.email ?? "", username: username)
                    self.userAuthManager.appState = .loggedIn
                }
            } else {
                DispatchQueue.main.async {
                    self.showError = true
                    self.errorMessage = "Failed to fetch user details."
                }
            }
        }
    }
    
    struct LoginViewController_Previews: PreviewProvider {
        static var previews: some View {
            LoginViewController(appState: .constant(.initial)).environmentObject(UserData())
        }
    }
}
