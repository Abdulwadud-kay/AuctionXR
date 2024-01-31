import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct RegisterViewController: View {
    @Environment(\.presentationMode) var presentationMode
    var showLogin: () -> Void
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @EnvironmentObject var userAuthManager: UserAuthenticationManager

    
    let backgroundColor = Color(hex: "f4e9dc")
    let buttonColor = Color(hex: "dbb88e")
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 15) {
                // Username Input
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .autocapitalization(.none)
                
                // Email Input
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                
                // Password Input
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                // Error Message Display
                if showError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                // Register Button
                Button("Register") {
                    registerUser()
                    
                }
                .padding(8)
                .background(buttonColor)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(.horizontal)
                
                
                
                // Navigation to Login on Successful Registration
                Button("Already have an account? Login") {
                                    showLogin()
                                }
                                .foregroundColor(buttonColor)
                                .underline()
                                .padding()
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(backgroundColor)
                            .edgesIgnoringSafeArea(.all)
                        }
                    }
                
    func registerUser() {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let user = authResult?.user {
                let db = Firestore.firestore()
                db.collection("users").document(user.uid).setData([
                    "username": username,
                    "email": email
                ]) { error in
                    if let error = error {
                        self.showError = true
                        self.errorMessage = error.localizedDescription
                    } else {
                        DispatchQueue.main.async {
                            
                            self.userAuthManager.appState = .loggedIn
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
                
            } else if let error = error {
                self.showError = true
                self.errorMessage = error.localizedDescription
            }
        }
        
    }
    }
struct RegisterViewController_Previews: PreviewProvider {
    static var previews: some View {
        RegisterViewController(showLogin: {}) // Provide an empty closure
            .environmentObject(UserAuthenticationManager())
    }
}
