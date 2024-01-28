import SwiftUI
import FirebaseAuth

struct LogoutView: View {
    @EnvironmentObject var userData: UserData
    @Binding var appState: AppState
    @State private var navigateToLogin = false // State to control navigation

    var body: some View {
        NavigationView { // Wrap your view in NavigationView
            VStack {
                Text("Logout")
                    .font(.title)
                Text("Are you sure you want to log out?")
                    .padding()
                
                Button("Logout", action: {
                    // Log the user out using FirebaseAuth
                    do {
                        try Auth.auth().signOut()
                        userData.updateLoginState(isLoggedIn: false) // Update the login state
                        print("User logged out")
                        
                        // Set navigateToLogin to true to trigger navigation
                        navigateToLogin = true
                    } catch {
                        print("Error logging out: \(error.localizedDescription)")
                    }
                })
                .foregroundColor(.red)
                
                // Use NavigationLink to navigate to the login page
                NavigationLink("", destination: LoginViewController(appState: $appState).environmentObject(userData), isActive: $navigateToLogin)
                    .opacity(0)
            }
            .navigationBarTitle("Logout", displayMode: .inline)
        }
    }
}
