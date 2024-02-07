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
    @State private var isImageUploaded = false
    @State private var saveButtonBlink = false

    // Placeholder image name (local asset)
    let placeholderImageName = "ArtifactImage"

    // Computed property to check if all fields are filled
    private var isFormComplete: Bool {
        !(title.isEmpty || description.isEmpty || startingPrice.isEmpty || selectedCategory == "Select Category" || !acceptTerms || selectedImage == nil)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Title").font(.headline)
                TextField("Enter title", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(4)
                .background(RoundedRectangle(cornerRadius: 5).stroke(Color.black, lineWidth: 0.5))
                Text("Description").font(.headline)
                TextEditor(text: $description)
                    .frame(height: 200)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.black, lineWidth: 0.5)) // Made the border line thicker and color black for clarity
                    .padding(.bottom, 10)

                Text("Starting Price").font(.headline)
                TextField("Enter price", text: $startingPrice)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(4)
                .background(RoundedRectangle(cornerRadius: 5).stroke(Color.black, lineWidth: 0.5)) // Brighter, more pronounced border
                                    .keyboardType(.numberPad)

                Text("Category").font(.headline)
                Picker("Select Category", selection: $selectedCategory) {
                    Text("Art").tag("Art")
                    Text("Collections").tag("Collections")
                    Text("Science").tag("Science")
                    Text("Special").tag("special")
                }.pickerStyle(MenuPickerStyle())

                Toggle(isOn: $acceptTerms) {
                    Text("Accept Terms & Conditions")
                }

                // Image Upload Buttons with black icon and text
                HStack {
                    Button(action: {
                        self.imageSource = .camera
                        self.showImagePicker = true
                    }) {
                        VStack {
                            Image(systemName: "camera").foregroundColor(.black)
                            Text("Take Picture").foregroundColor(.black)
                        }
                    }.buttonStyle(PlainButtonStyle()) // Use PlainButtonStyle for more control
                    Spacer()
                    Button(action: {
                        self.imageSource = .photoLibrary
                        self.showImagePicker = true
                    }) {
                        VStack {
                            Image(systemName: "doc").foregroundColor(.black)
                            Text("Upload from File").foregroundColor(.black)
                        }
                    }.buttonStyle(PlainButtonStyle())

                    if isImageUploaded {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                }

                // Buttons row
                HStack {
                    // Changed to clickable text "Save for later"
                    Text("Save for later")
                        .underline()
                        .foregroundColor(.blue)
                        .onTapGesture {
                            // Save functionality here
                        }
                    Spacer()

                    // Submit Button
                    Button("Submit") {
                        submitArtifact()
                    }
                    .padding(10)
                    .background(isFormComplete ? Color("dbb88e") : Color.clear)
                    .foregroundColor(isFormComplete ? .white : .black)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                }

            }.padding()
        }.sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage, sourceType: imageSource)
        }.background(Color(hex: "f4e9dc"))
         .navigationBarTitle("Create Artifact", displayMode: .inline)
        .onChange(of: selectedImage) { _ in
            isImageUploaded = selectedImage != nil
        }
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
