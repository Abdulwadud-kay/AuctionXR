// ContentView.swift



import SwiftUI

struct ContentView: View {
    var viewModel = ArtifactsViewModel()
    @EnvironmentObject var userAuthManager: UserManager

    var body: some View {
        switch userAuthManager.appState {
        case .initial, .loggedOut:
            AuthenticationView().environmentObject(userAuthManager)
        case .loggedIn:
            MainTabView()  // Replace with your actual MainTabView
        }
    }
    
    
}



struct AuthenticationView: View {
    @State private var showingRegister = false // Use this state to track whether to show the registration view
    @EnvironmentObject var userAuthManager: UserManager

    var body: some View {
        if showingRegister {
            RegisterViewController(showLogin: { showingRegister = false }) {
                // Handle successful registration
                self.userAuthManager.verifyAccountSetup() // Verify account setup after successful registration
                self.showingRegister = false // Dismiss the registration view
            }
            .environmentObject(userAuthManager)
        } else if userAuthManager.isLoggedIn {
            if userAuthManager.isAccountSetup {
                MainTabView()
            } else {
                AccountDetailsView()
                    .environmentObject(userAuthManager)
            }
        } else {
            LoginViewController(showRegister: { showingRegister = true })
                .environmentObject(userAuthManager)
        }
    }
}







struct MainTabView: View {
    @State private var selection = 0
    @EnvironmentObject var userAuthManager: UserManager
    
    var body: some View {
        TabView(selection: $selection) {
            HomeViewController() // No need to pass appState here
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)
            ArtifactViewController()
                .tabItem {
                    Label("Artifacts", systemImage: "book.closed")
                }
                .tag(1)
            NotificationView()
                .tabItem {
                    Label("Notifications", systemImage: "bell")
                }
                .tag(2)
            SoldItemsView()
                .tabItem {
                    Label("bids", systemImage: "cart")
                }
                .tag(3)
        }
        .onAppear {
            UITabBar.appearance().backgroundColor = UIColor(Color(hex:"f4e9dc"))
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(UserManager())
    }
}

