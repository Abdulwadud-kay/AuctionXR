import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var userAuthManager: UserAuthenticationManager
    @State private var isEditingProfile = false
    @State private var isLoggingOut = false

    var body: some View {
        NavigationView {
            List {
                VStack {
                    HStack {
                        if let image = userData.userImage {
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
                                    Text(userData.userInitial)
                                        .foregroundColor(.white)
                                        .font(.title)
                                )
                        }
                        
                        Text(userData.userEmail)
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
                            UserProfileEditView()
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
                    }
                }

                private func logoutUser() {
                    do {
                        try Auth.auth().signOut()
                        userData.updateLoginState(isLoggedIn: false)
                        userAuthManager.appState = .loggedOut
                    } catch {
                        print("Error logging out: \(error.localizedDescription)")
                    }
                }
            }

            struct ProfileView_Previews: PreviewProvider {
                static var previews: some View {
                    ProfileView()
                        .environmentObject(UserData())
                        .environmentObject(UserAuthenticationManager())
                }
            }
