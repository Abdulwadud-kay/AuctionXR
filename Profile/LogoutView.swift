import SwiftUI
import FirebaseAuth

struct LogoutView: View {
    @EnvironmentObject var userAuthManager: UserAuthenticationManager
    @EnvironmentObject var userData: UserData
    @State private var isLoggingOut = false // State to control the logout confirmation

    var body: some View {
        NavigationView {
            VStack {
                Text("Logout")
                    .font(.title)
                Text("Are you sure you want to log out?")
                    .padding()
                
                Button("Logout") {
                    isLoggingOut = true
                }
                .foregroundColor(.red)
                .alert(isPresented: $isLoggingOut) {
                    Alert(
                        title: Text("Confirm Logout"),
                        message: Text("Are you sure you want to log out?"),
                        primaryButton: .destructive(Text("Logout")) {
                            logoutUser()
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            .navigationBarTitle("Logout", displayMode: .inline)
        }
    }

    private func logoutUser() {
        do {
            try Auth.auth().signOut()
            userData.updateLoginState(isLoggedIn: false)
            userAuthManager.appState = .loggedOut
            print("User logged out")
        } catch {
            print("Error logging out: \(error.localizedDescription)")
        }
    }
}

// Assuming you have PreviewProvider here
