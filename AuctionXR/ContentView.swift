// ContentView.swift



import SwiftUI

struct ContentView: View {
    var viewModel = ArtifactsViewModel()
    @EnvironmentObject var userAuthManager: UserAuthenticationManager

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
    @State private var showingLogin = true
    @EnvironmentObject var userAuthManager: UserAuthenticationManager

    var body: some View {
        if showingLogin {
            LoginViewController(showRegister: { showingLogin = false })
                .environmentObject(userAuthManager)
        } else {
            RegisterViewController(showLogin: { showingLogin = true })
                .environmentObject(userAuthManager)
        }
    }
}







struct MainTabView: View {
    @State private var selection = 0
    @EnvironmentObject var userAuthManager: UserAuthenticationManager
    
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
        }
        .onAppear {
            UITabBar.appearance().backgroundColor = UIColor(Color(hex:"f4e9dc"))
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(UserAuthenticationManager())
    }
}

