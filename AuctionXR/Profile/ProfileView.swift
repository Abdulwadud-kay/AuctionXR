import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @EnvironmentObject var userManager: UserManager
    @State private var isEditingProfile = false
    @State private var isLoggingOut = false
    @State private var newUsername: String = ""
    @State private var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                VStack {
                    HStack {
                        profileImage
                        usernameField
                        Spacer()
                    }.padding()
                }.listRowBackground(Color(.white))
                generalSection
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("Profile", displayMode: .inline)
            .navigationBarItems(trailing: editButton)
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
            .sheet(isPresented: $userManager.isImagePickerPresented) {
                ImagePicker(selectedImage: $selectedImage, sourceType: .photoLibrary) { image in
                    // Handle the selected image
                    if let image = image {
                        // Update the user manager with the selected image
                        userManager.userImage = image
                    }
                    // Dismiss the image picker
                    userManager.isImagePickerPresented = false
                }
            }
        }
    }
    
    private var profileImage: some View {
        ZStack {
            if let image = userManager.userImage {
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
                        Group {
                            if !isEditingProfile {
                                Text(String(userManager.userInitial))
                                    .foregroundColor(.white)
                                    .font(.title)
                                
                            }
                        }
                    )
            }
            if isEditingProfile {
                Button(action: userManager.selectImage) {
                    Text("Edit Image")
                        .foregroundColor(.white)
                        .font(.system(size: 10))
                        .frame(width: 60, height: 60)
                        .background(Color.black.opacity(0.5))
                        .clipShape(Circle())
                }
            }
        }
    }
    
    private var usernameField: some View {
        Group {
            if isEditingProfile {
                TextField("Enter new username", text: $newUsername)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            } else {
                Text(userManager.username)
                    .font(.title3)
            }
        }
    }
    
    private var generalSection: some View {
        Section(header: Text("General")) {
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
    }

    private var editButton: some View {
        Button(isEditingProfile ? "Save" : "Edit") {
            if isEditingProfile {
                userManager.updateUsername(newUsername)
                
                userManager.saveProfileChanges()
            }
            isEditingProfile.toggle()
        }
    }

    
    private func logoutUser() {
        do {
            try Auth.auth().signOut()
            userManager.isLoggedIn = false
            userManager.appState = .loggedOut
            print("User logged out")
        } catch {
            print("Error logging out: \(error.localizedDescription)")
        }
    }
}
//    private func updateUserImage(_ image: UIImage?) {
//            userManager.userImage = image
//            userManager.profileImageChanged.send() // Notify profile image change
//        }


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let userManager = UserManager()
        return ProfileView()
            .environmentObject(userManager)
    }
}
