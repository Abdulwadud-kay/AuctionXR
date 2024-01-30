import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @EnvironmentObject var sessionManager: UserData
        @Binding var appState: AppState
        @State private var isEditingProfile = false // State to control profile editing view
        @State private var isLoggingOut = false
        @State private var navigateToLogin = false
        @EnvironmentObject var userAuthManager: UserAuthenticationManager

    var body: some View {
        NavigationView {
            List {
                VStack {
                    HStack {
                        if let image = sessionManager.userImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                        } else {
                            Circle()
                                .fill(Color.gray)
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Text(sessionManager.userInitial)
                                        .foregroundColor(.white)
                                        .font(.title)
                                )
                        }
                        
                        Text(sessionManager.userEmail)
                            .font(.title3)
                            .padding(.leading)
                        
                        Spacer()
                    }
                    .padding()
                }
                .listRowBackground(Color("f4e9dc"))
                
                Section(header: Text("General")) {
                    NavigationLink(destination: HistoryView()) {
                        Label("History", systemImage: "clock")
                    }
                    NavigationLink(destination: HelpView()) {
                        Label("Help", systemImage: "questionmark.circle")
                    }
                    NavigationLink(destination: SettingsView()) {
                        Label("Settings", systemImage: "gear")
                    }
                    Button("Logout") {
                        isLoggingOut = true
                    }
                    .foregroundColor(.red)
                }
                
                Section(header: Text("Information")) {
                    NavigationLink(destination: FAQsView()) {
                        Label("FAQs", systemImage: "text.book.closed")
                    }
                    NavigationLink(destination: AboutUsView()) {
                        Label("About Us", systemImage: "info.circle")
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
                        .navigationBarTitle("Profile", displayMode: .inline)
                        .navigationBarItems(trailing: Button("Edit") {
                            isEditingProfile = true
                        })
                        .sheet(isPresented: $isEditingProfile) {
                            // UserProfileEditView...
                        }
                        .alert(isPresented: $isLoggingOut) {
                            Alert(
                                title: Text("Logout"),
                                message: Text("Are you sure you want to logout?"),
                                primaryButton: .destructive(Text("Logout")) {
                                    logoutUser()
                                },
                                secondaryButton: .cancel()
                            )
                        }
                        NavigationLink(destination: LoginViewController(appState: $appState).environmentObject(sessionManager), isActive: $navigateToLogin) {
                            EmptyView()
                        }
                        .hidden()
                    }
                }

                private func logoutUser() {
                    do {
                        try Auth.auth().signOut()
                        sessionManager.updateLoginState(isLoggedIn: false)
                        appState = .initial
                        navigateToLogin = true // Trigger navigation to login view
                    } catch {
                        print("Error logging out: \(error.localizedDescription)")
                    }
                }
            }

    
    struct ProfileView_Previews: PreviewProvider {
        @State static var appState = AppState.loggedOut
        
        static var previews: some View {
            ProfileView(appState: $appState)
                .environmentObject(UserData()) // <-- Make sure UserData conforms to ObservableObject
                .environmentObject(UserAuthenticationManager()) // <-- Assuming you need to pass this too for the preview
        }
    }

