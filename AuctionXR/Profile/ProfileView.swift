import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

struct ProfileView: View {
    @State private var isImagePickerPresented = false
    @EnvironmentObject var userAuthManager: UserAuthenticationManager
    @State private var isEditingProfile = false
    @State private var isLoggingOut = false
    @State private var newUsername: String = ""
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
                }.listRowBackground(Color(hex:"f4e9dc"))
                generalSection
                informationSection
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("Profile", displayMode: .inline)
            .navigationBarItems(trailing: editButton)
            .alert(isPresented: $isLoggingOut, content: logoutAlert)
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(selectedImage: $userAuthManager.userData.userImage, sourceType: .photoLibrary) { image in
                    if let image = image {
                        userAuthManager.userData.userImage = image
                        saveProfileChanges()
                    }
                }
            }
            .onChange(of: userAuthManager.appState) { appState in
                if appState == .loggedOut {
                    // User is logged out, handle accordingly (e.g., show login screen)
                    // For now, we'll just dismiss the profile view
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
    private var profileImage: some View {
        ZStack {
            if let image = userAuthManager.userData.userImage {
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
                                Text(userAuthManager.userData.userInitial)
                                    .foregroundColor(.white)
                                    .font(.title)
                            }
                        }
                    )
            }
            if isEditingProfile {
                Button(action: selectImage) {
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
                Text(userAuthManager.userData.username)
                    .font(.title3)
            }
        }
    }

    private var generalSection: some View {
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
    }

    private var informationSection: some View {
        Section(header: Text("Information")) {
            NavigationLink(destination: FAQsView()) {
                Label("FAQs", systemImage: "text.book.closed")
            }
            NavigationLink(destination: AboutUsView()) {
                Label("About Us", systemImage: "info.circle")
            }
        }
    }

    private var editButton: some View {
        Button(isEditingProfile ? "Save" : "Edit") {
            if isEditingProfile {
                saveProfileChanges()
            }
            isEditingProfile.toggle()
        }
    }

    private func selectImage() {
        isImagePickerPresented = true
    }

    private func saveProfileChanges() {
            // Save the new username
            if !newUsername.isEmpty {
                updateUsernameInFirestore(newUsername)
            }

            // Save the new image
            if let newImage = userAuthManager.userData.userImage {
                userAuthManager.userData.uploadProfileImage(newImage) { result in
                    switch result {
                    case .success(let imageUrl):
                        self.updateImageUrlInFirestore(imageUrl)
                    case .failure(let error):
                        print("Error uploading image: \(error.localizedDescription)")
                    }
                }
            }
        }
    private func updateUsernameInFirestore(_ newUsername: String) {
        let db = Firestore.firestore()
        if let userId = Auth.auth().currentUser?.uid {
            db.collection("users").document(userId).updateData(["username": newUsername]) { error in
                if let error = error {
                    print("Error updating username: \(error.localizedDescription)")
                } else {
                    // Update the username in UserData immediately after Firestore update
                    DispatchQueue.main.async {
                        self.userAuthManager.userData.username = newUsername
                    }
                }
            }
        }
    }
    private func updateImageUrlInFirestore(_ imageUrl: String) {
        let db = Firestore.firestore()
        if let userId = Auth.auth().currentUser?.uid {
            db.collection("users").document(userId).updateData(["imageUrl": imageUrl]) { error in
                if let error = error {
                    print("Error updating image URL: \(error.localizedDescription)")
                }
            }
        }
    }

    private func logoutAlert() -> Alert {
        Alert(
            title: Text("Logout"),
            message: Text("Are you sure you want to logout?"),
            primaryButton: .destructive(Text("Logout")) {
                logoutUser()
            },
            secondaryButton: .cancel()
        )
    }

    private func logoutUser() {
        do {
            try Auth.auth().signOut()
            userAuthManager.userData.updateLoginState(isLoggedIn: false)
            userAuthManager.appState = .loggedOut
        } catch {
            print("Error logging out: \(error.localizedDescription)")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let userAuthManager = UserAuthenticationManager()
        return ProfileView()
            .environmentObject(userAuthManager)
    }
}
