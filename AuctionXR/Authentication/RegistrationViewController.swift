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
    @State private var isPasswordVisible = false

    @EnvironmentObject var userAuthManager: UserManager
    
    let backgroundColor = Color(.white)
    let buttonColor = Color(hex: "#5729CE")
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 15) {
                Image("auctionbox")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 260, minHeight: 50)

                
                TextField("Username", text: $username)
                .autocapitalization(.none)
                .padding(.horizontal)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(15)
                .padding(.horizontal)

                

                TextField("Email", text: $email)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .padding(.horizontal)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(15)
                .padding(.horizontal)

                

                HStack {
                    if isPasswordVisible {
                    TextField("Password", text: $password)
                    } else {
                    SecureField("Password", text: $password)
                        }
                    Button(action: {
                        self.isPasswordVisible.toggle()
                    }) {
                    Image(systemName: self.isPasswordVisible ? "eye.fill" : "eye.slash.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(15)
                            .padding(.horizontal)
                            .padding(.top, 10)

                
                if showError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Button("Register") {
                    registerUser()
                }
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: 360, minHeight: 50)
                .background(buttonColor)
                .cornerRadius(15)

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
