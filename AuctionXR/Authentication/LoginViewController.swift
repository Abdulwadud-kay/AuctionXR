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
    
    init(appState: Binding<AppState>) {
            self._appState = appState
            // Other initializations..
        }
    
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

                NavigationLink(destination: RegisterViewController().environmentObject(userAuthManager.userData)) {
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
                let db = Firestore.firestore()
                db.collection("users").document(user.uid).getDocument { document, error in
                    if let document = document, document.exists {
                        let username = document.get("username") as? String ?? "Unknown"
                        userAuthManager.userData.updateUserDetails(email: user.email ?? "", username: username)
                        
                        // Set appState to initial to trigger PreviewView
                        userAuthManager.appState = .initial
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            userAuthManager.checkUserLoggedIn() // This will set appState to .loggedIn
                        }
                    } else {
                        showError = true
                        errorMessage = "Failed to fetch user details."
                    }
                }
            } else {
                showError = true
                errorMessage = error?.localizedDescription ?? "Login error"
            }
        }
    }
    
    
    struct LoginViewController_Previews: PreviewProvider {
        static var previews: some View {
            LoginViewController(appState: .constant(.initial)).environmentObject(UserData())
        }
    }
}
