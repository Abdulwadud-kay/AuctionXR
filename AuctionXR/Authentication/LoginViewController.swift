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
    @EnvironmentObject var userAuthManager: UserAuthenticationManager
    
    let backgroundColor = Color(hex: "f4e9dc")
    let buttonColor = Color(hex: "dbb88e")
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 15) {
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
                
                Button("Don't have an account? Register here") {
                    showRegister()
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
            .environmentObject(UserAuthenticationManager())
            .environmentObject(UserData())
    }
}
