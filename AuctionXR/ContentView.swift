// ContentView.swift

import SwiftUI

struct ContentView: View {
@EnvironmentObject var userAuthManager: UserAuthenticationManager

    var body: some View {
        NavigationStack {
            switch userAuthManager.appState {
            case .initial:
                PreviewView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            userAuthManager.checkUserLoggedIn()
                        }
                    }

            case .loggedIn:
                MainTabView().environmentObject(userAuthManager.userData)

            case .loggedOut:
                LoginViewController(appState: $userAuthManager.appState).environmentObject(userAuthManager.userData)

            }
        }
    }
}




struct MainTabView: View {
    @State private var selection = 0
    @EnvironmentObject var userAuthManager: UserAuthenticationManager // Ensure you have access to this
    
    var body: some View {
        TabView(selection: $selection) {
            HomeViewController(appState: $userAuthManager.appState) // Pass the appState here
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
