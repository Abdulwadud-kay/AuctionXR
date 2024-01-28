import SwiftUI
import FirebaseStorage
import FirebaseFirestore

struct CreateArtifactView: View {
    // State variables for form fields
    @State private var description: String = ""
    @State private var startingPrice: String = ""
    @State private var title: String = ""
    @State private var selectedCategory: String = "Select Category"
    @State private var acceptTerms: Bool = false
    @State private var showImagePicker = false
    @State private var imageSource: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?

    // Placeholder image name (local asset)
    let placeholderImageName = "ArtifactImage"

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                // Title field
                Text("Title").font(.headline)
                TextField("Enter title", text: $title).textFieldStyle(RoundedBorderTextFieldStyle())

                // Description field
                Text("Description").font(.headline)
                TextField("Enter description", text: $description).textFieldStyle(RoundedBorderTextFieldStyle())

                // Starting price field
                Text("Starting Price").font(.headline)
                TextField("Enter price", text: $startingPrice).textFieldStyle(RoundedBorderTextFieldStyle()).keyboardType(.numberPad)

                // Category picker
                Text("Category").font(.headline)
                Picker("Select Category", selection: $selectedCategory) {
                    Text("Art").tag("Art")
                    Text("Collections").tag("Collections")
                    Text("Science").tag("Science")
                    Text("Special").tag("special")
                }.pickerStyle(MenuPickerStyle())

                // Terms and conditions toggle
                Toggle(isOn: $acceptTerms) {
                    Text("Accept Terms & Conditions")
                }

                // Image Upload Buttons
                HStack {
                    Button(action: {
                        self.imageSource = .camera
                        self.showImagePicker = true
                    }) {
                        VStack {
                            Image(systemName: "camera.fill")
                            Text("Take Picture")
                        }
                    }.buttonStyle(SecondaryButtonStyle())
                    Spacer()
                    Button(action: {
                        self.imageSource = .photoLibrary
                        self.showImagePicker = true
                    }) {
                        VStack {
                            Image(systemName: "doc.fill")
                            Text("Upload from File")
                        }
                    }.buttonStyle(SecondaryButtonStyle())
                }

                // Submit Button
                Button("Submit") {
                    submitArtifact()
                }.padding(10)
                .background(Color("dbb88e"))
                .foregroundColor(.white)
                .cornerRadius(10)
            }.padding()
        }.sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage, sourceType: imageSource)
        }.background(Color(hex: "f4e9dc"))
         .navigationBarTitle("Create Artifact", displayMode: .inline)
    }

    // Submit artifact function
    private func submitArtifact() {
        let startingPriceDouble = Double(startingPrice) ?? 0.0
        if let selectedImage = selectedImage {
            uploadImage(selectedImage) { imageUrl in
                self.saveArtifact(title: self.title, description: self.description, startingPrice: startingPriceDouble, category: self.selectedCategory, imageUrl: imageUrl)
            }
        } else {
            self.saveArtifact(title: self.title, description: self.description, startingPrice: startingPriceDouble, category: self.selectedCategory, imageUrl: nil)
        }
    }

    // Upload image to Firebase Storage and retrieve URL
    private func uploadImage(_ image: UIImage, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Could not convert the image to Data")
            completion(nil)
            return
        }

        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child("images/\(UUID().uuidString).jpg")

        imageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                completion(nil)
                return
            }

            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    print("Error fetching downloadURL: \(error?.localizedDescription ?? "")")
                    completion(nil)
                    return
                }

                completion(downloadURL.absoluteString)
            }
        }
    }

    // Save artifact details to Firestore
    private func saveArtifact(title: String, description: String, startingPrice: Double, category: String, imageUrl: String?) {
        let db = Firestore.firestore()
        db.collection("artifacts").addDocument(data: [
            "title": title,
            "description": description,
            "startingPrice": startingPrice,
            "category": category,
            "imageUrl": imageUrl ?? placeholderImageName,
            "isBidded": false
            // Add other fields as needed
        ]) { error in
            if let error = error {
                print("Error saving artifact: \(error.localizedDescription)")
            } else {
                print("Artifact saved successfully")
            }
        }
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    let accentColor = Color("dbb88e")

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.all, 4)
            .background(accentColor.opacity(configuration.isPressed ? 0.5 : 1))
            .foregroundColor(.white)
            .cornerRadius(8)
    }
}

struct CreateArtifactView_Previews: PreviewProvider {
    static var previews: some View {
        CreateArtifactView()
    }
}
