// ContentView.swift

import SwiftUI


struct ContentView: View {
    @EnvironmentObject var userAuthManager: UserAuthenticationManager

    var body: some View {
            NavigationStack {
                if userAuthManager.isLoading {
                    PreviewView()  // A simple view that indicates loading is in progress
                } else {
                    viewForCurrentState()
                }
            }
        }
    @ViewBuilder
    private func viewForCurrentState() -> some View {
        switch userAuthManager.appState {
        case .initial:
            PreviewView()
                .onAppear {
                    userAuthManager.checkUserLoggedIn()
                }

        case .loggedIn:
            MainTabView()

        case .loggedOut:
            LoginViewController() // Updated to remove the appState parameter
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
            UITabBar.appearance().backgroundColor = UIColor(Color("f4e9dc"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(UserAuthenticationManager())
    }
}

