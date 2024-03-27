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
    @EnvironmentObject var userAuthManager: UserManager
    
    let backgroundColor = Color(.white)
    let buttonColor = Color(hex: "#5729CE")
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 15) {
                HStack {
                    Image(systemName: "person")
                        .foregroundColor(Color(buttonColor))
                        .padding(.leading, 8)
                    TextField("Username", text: $username)
                        .autocapitalization(.none)
                }
                .padding(.horizontal)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                
                HStack {
                    Image(systemName: "envelope")
                        .foregroundColor(Color(buttonColor))
                        .padding(.leading, 3)
                    TextField("Email", text: $email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                }
                .padding(.horizontal)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                
                HStack {
                    Image(systemName: "lock")
                        .foregroundColor(Color(buttonColor))
                        .padding(.leading, 8)
                    SecureField("Password", text: $password)
                }
                .padding(.horizontal)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 8)
                
                if showError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Button("Register") {
                    registerUser()
                }
                .padding(.all,11)
                .background(buttonColor)
                .foregroundColor(.white)
                .cornerRadius(16)
      
                
                
                
//                Spacer()
//                    .frame(height: 10)
                // Navigation to Login on Successful Registration
//                Button("Already have an account? Login") {
//                    showLogin()
//                }
//                .foregroundColor(buttonColor)
//                .underline()
//                .padding()
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
                    "email": email,
                    "isAccountSetup": false // Initialize the account setup status
                ]) { error in
                    if let error = error {
                        print("Error registering user:", error.localizedDescription)
                        self.showError = true
                        self.errorMessage = error.localizedDescription
                    } else {
                        DispatchQueue.main.async {
                            self.userAuthManager.fetchUserDetails(user)
                            self.presentationMode.wrappedValue.dismiss()
                            
                            // Access isLoggedIn directly without using the $ sign
                            self.userAuthManager.isLoggedIn = true
                            self.userAuthManager.verifyAccountSetup()
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
                .environmentObject(UserManager())
        }
    }
