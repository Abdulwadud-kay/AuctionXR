// ContentView.swift



// ContentView.swift


import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userAuthManager: UserManager
    @State private var showingInitialView = true // Control whether to show PreviewView or not

    var body: some View {
        // Check if showing the initial view
        if showingInitialView {
            PreviewView()
                .environmentObject(userAuthManager)
                .onAppear {
                    // Use a timer to switch to the appropriate view after 4 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        showingInitialView = false
                    }
                }
        } else {
            // Switch to the appropriate view based on user's state
            switch userAuthManager.appState {
            case .loggedOut:
                AuthenticationView().environmentObject(userAuthManager)
            case .loggedIn:
                MainTabView().environmentObject(userAuthManager)
            default:
                // Handle other states if needed
                EmptyView()
            }
        }
    }
}


struct AuthenticationView: View {
    @EnvironmentObject var userAuthManager: UserManager
    @State private var showingRegister = false

    var body: some View {
        if userAuthManager.isLoggedIn {
            MainTabView()
        } else {
            LoginViewController(showRegister: { self.showingRegister = true })
                .environmentObject(userAuthManager)
                .sheet(isPresented: $showingRegister, onDismiss: {
                    self.showingRegister = false
                }) {
                    RegisterViewController {
                        self.userAuthManager.verifyAccountSetup()
                    }
                    .environmentObject(userAuthManager)
                }
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

