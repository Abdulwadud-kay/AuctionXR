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
                
                Button("Don't have an account? Register here") {
                    showRegister()
                }
                .foregroundColor(buttonColor)
                .underline()
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
            .background(backgroundColor)
        }
    }
    
    
    func loginUser() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let user = authResult?.user {
                // Call fetchUserDetails from UserAuthenticationManager
                self.userAuthManager.fetchUserDetails(user)
                self.presentationMode.wrappedValue.dismiss()
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
        LoginViewController(showRegister: {}) // Provide an empty closure
            .environmentObject(UserAuthenticationManager())
    }
}

