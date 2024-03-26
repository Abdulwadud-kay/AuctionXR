import SwiftUI
import Firebase


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct AuctionXApp: App {
    @StateObject var userAuthManager = UserManager()
//    @StateObject var userData = UserData()
    @StateObject var artifactsViewModel = ArtifactsViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    init() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor(Color(.white))

        // Set the tab bar item's active and inactive colors
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color(hex:"#5729CE"))
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(Color( hex:"#5729CE"))]
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.gray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.gray]

        // Apply the appearance
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
//                .environmentObject(userData)
                .environmentObject(userAuthManager)
                .environmentObject(artifactsViewModel)
        }
    }
}
