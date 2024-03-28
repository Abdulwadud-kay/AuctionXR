import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct LoginViewController: View {
    @Environment(\.presentationMode) var presentationMode
    var showRegister: () -> Void
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var isPasswordVisible = false
    @EnvironmentObject var userAuthManager: UserManager
    @State private var isRegistering = false

    
    let backgroundColor = Color(.white)
    let buttonColor = Color(hex: "#ff5f00")
    let otherColor = Color(hex: "#5729CE")
    
    var body: some View {
            NavigationStack {
                VStack(spacing: 15) {
                    Image("auctionbox")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: 260, minHeight: 50)

                    HStack {
                        TextField("Email", text: $email)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(15)
                            .padding(.horizontal)

                    }
                    
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

                    
                    if showError {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }
                    
                    Button(action: {
                                    isRegistering = true
                        }) {
                        Text("Forgot password?")
                            .foregroundColor(.gray)
                            .padding(.top, 5)
                                }

                    
                    Button("Login") {
                        loginUser()
                    }
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: 365, minHeight: 50)
                    .background(otherColor)
                    .cornerRadius(15)
                    .padding(.top, 10)

                    
                    Spacer()
                        .frame(height: 10)
                    
                    Button("Don't have an account? Register here") {
                        self.showRegister()
                    }
                    .foregroundColor(otherColor)
                    .underline()
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
                    self.userAuthManager.fetchUserDetails(user)
                } else if let error = error {
                    DispatchQueue.main.async {
                        self.showError = true
                        self.errorMessage = error.localizedDescription
                    }
                }
            }
        }
    }
struct LoginViewController_Previews: PreviewProvider {
    static var previews: some View {
        LoginViewController(showRegister: {})
            .environmentObject(UserManager())
//            .environmentObject(UserData())
    }
}
