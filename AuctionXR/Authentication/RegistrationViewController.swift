import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct RegisterViewController: View {
    @EnvironmentObject var userAuthManager: UserAuthenticationManager
    @Binding var appState: AppState
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isRegistrationSuccessful = false
    @State private var showError = false
    @State private var errorMessage = ""
    
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
                NavigationLink(destination: LoginViewController(appState: $appState).environmentObject(userAuthManager)) {
                    Text("Already have an account? Login")
                        .foregroundColor(buttonColor)
                        .underline()
                }
                
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(backgroundColor)
            .edgesIgnoringSafeArea(.all)
        }
        
    }
    
    // Registration Function
    // Registration Function
    // Registration Function
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
                            // Set appState to initial to trigger the preview or a loading view
                            userAuthManager.appState = .initial

                            // Check user logged in after a short delay
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                userAuthManager.checkUserLoggedIn() // This should set appState to .loggedIn
                            }
                        }
                    }
                }
            } else if let error = error {
                self.showError = true
                self.errorMessage = error.localizedDescription
            }
        }
    }

    
    struct RegisterViewController_Previews: PreviewProvider {
        static var previews: some View {
            RegisterViewController(appState: .constant(.initial)).environmentObject(UserAuthenticationManager())
        }
    }
}
