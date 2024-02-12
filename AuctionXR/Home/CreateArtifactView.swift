
import SwiftUI
import PhotosUI
import FirebaseStorage
import FirebaseFirestore
import AVKit

struct CreateArtifactView: View {
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var startingPrice: String = ""
    @State private var selectedCategory: String = "Select Category"
    @State private var acceptTerms: Bool = false
    @State private var selectedImages: [UIImage] = []
    @State private var selectedVideoURL: URL?
    @State private var showImagePicker: Bool = false
    @State private var showVideoPicker: Bool = false
    @State private var bidEndDate: Date = Date()
    @State private var minBidEndDate: Date = Date().addingTimeInterval(30 * 60)
    @State private var maxBidEndDate: Date = Calendar.current.date(byAdding: .year, value: 2, to: Date())! // 2 years from now

    
    let minBidDuration: TimeInterval = 30 * 60 // 30 minutes in seconds
    let maxBidDuration: TimeInterval = 2 * 365 * 24 * 60 * 60 // 2 years in seconds
    let bidEndDateRange: ClosedRange<Date> = Date()...(Date() + 2 * 365 * 24 * 60 * 60) // From now to 2 years in the future
    
    let backgroundColor = Color(hex: "dbb88e") // Ensure you have a method to initialize Color with hex.
    let  iconColor = Color(.white)
    let gradientTop = Color(hex: "dbb88e")
    let gradientBottom = Color.white

    var body: some View {
        ScrollView (showsIndicators: false){
            VStack(alignment: .leading, spacing: 20) {
                Spacer(minLength: 10)
                TextField("Title", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                VStack(alignment: .leading) {
                    Text("Description")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(.horizontal)
                    TextEditor(text: $description)
                        .frame(height: 100)
                        .cornerRadius(5)
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 0))
                        .padding()
                        .foregroundColor(.gray) // Placeholder text color
                }
                
                TextField("Starting Price", text: $startingPrice)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                VStack(alignment: .leading) {
                    Text("Bid End Date")
                        .font(.headline)
                        .padding(.horizontal)
                    DatePicker(
                        "Bid End Date",
                        selection: $bidEndDate,
                        in: minBidEndDate...maxBidEndDate,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .onChange(of: bidEndDate) { newValue in
                        // Check if the selected date is today; if so, ensure time is at least 30 mins from now
                        if Calendar.current.isDateInToday(newValue) {
                            let nowPlus30Mins = Date().addingTimeInterval(30 * 60)
                            if newValue < nowPlus30Mins {
                                bidEndDate = nowPlus30Mins
                            }
                        }
                    }
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding(.horizontal)
                }

                
                Picker("Category", selection: $selectedCategory) {
                    Text("Art").tag("Art")
                    Text("Collections").tag("Collections")
                    Text("Science").tag("Science")
                    Text("Special").tag("Special")
                }
                .pickerStyle(MenuPickerStyle())
                .padding(.horizontal)
                
                Toggle("Accept Terms & Conditions", isOn: $acceptTerms)
                    .padding(.horizontal)
                
                HStack(spacing: 30) { // Adjust spacing as needed
                    Button(action: {
                        showImagePicker = true
                    }) {
                        VStack {
                            Image(systemName: "camera.fill")
                                .font(.title)
                                .foregroundColor(.white)
                            Text("Add Image")
                                .foregroundColor(.white)
                                .font(.caption)
                        }
                    }
                    .disabled(selectedImages.count >= 4)
                    
                    Button(action: {
                        showVideoPicker = true
                    }) {
                        VStack {
                            Image(systemName: "video.fill")
                                .font(.title)
                                .foregroundColor(.white)
                            Text("Add Video")
                                .foregroundColor(.white)
                                .font(.caption)
                        }
                    }
                    .disabled(selectedVideoURL != nil)
                }
                .padding()
                
                
                
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(selectedImages.indices, id: \.self) { index in
                            ZStack(alignment: .topTrailing) {
                                Image(uiImage: selectedImages[index])
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(8)

                                Button(action: {
                                    selectedImages.remove(at: index)
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.black)
                                        .padding(3)
                                }
                                .padding(.trailing, 5)
                            }
                        }
                    }
                }
                .frame(height: 120)
                .padding(.vertical)

                
                if let selectedVideoURL = selectedVideoURL {
                    VideoPlayer(player: AVPlayer(url: selectedVideoURL))
                        .frame(height: 200)
                    
                    Button(action: {
                        self.selectedVideoURL = nil
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.black)
                            .padding(3)
                    }
                }
            VStack(spacing: 20) {
                HStack {
                    Text("Save for Later")
                        .font(.subheadline)
                        .foregroundColor(backgroundColor)
                        .onTapGesture {
                            // Implement Save for Later functionality
                        }
                    
                    Spacer()
                    
                    Button("Submit") {
                        submitArtifact()
                    }
                    
                    .disabled(!isFormComplete)
                    .padding()
                    .frame(width: 100, height: 40)
                    .background(backgroundColor)
                    .cornerRadius(25)
                    .foregroundColor(Color.white)
                }
                .padding([.horizontal, .bottom])
                .padding(.top, -10)
              }
            
            }
        }
        .background(LinearGradient(gradient: Gradient(colors: [gradientTop, gradientBottom]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $showImagePicker) {
                   PhotoPicker(selectedImages: $selectedImages, limit: 4 - selectedImages.count) // Adjust the limit based on already selected images
               }
        .sheet(isPresented: $showVideoPicker) {
            VideoPicker(selectedVideoURL: $selectedVideoURL)
        }
    }

    private var isFormComplete: Bool {
        !title.isEmpty && !description.isEmpty && !startingPrice.isEmpty && selectedCategory != "Select Category" && acceptTerms && (!selectedImages.isEmpty || selectedVideoURL != nil)
    }
    private func submitArtifact() {
        let storageRef = Storage.storage().reference()
        
        for image in selectedImages {
            guard let imageData = image.jpegData(compressionQuality: 0.8) else { continue }
            let imageRef = storageRef.child("artifacts/\(UUID().uuidString).jpg")

            imageRef.putData(imageData, metadata: nil) { metadata, error in
                guard metadata != nil else {
                    print(error?.localizedDescription ?? "Unknown error")
                    return
                }
                imageRef.downloadURL { url, error in
                    guard let downloadURL = url else {
                        print(error?.localizedDescription ?? "Unknown error")
                        return
                    }
                    print("Image URL: \(downloadURL.absoluteString)")
     
                }
            }
        }

 
    }
}


struct CreateArtifactView_Previews: PreviewProvider {
    static var previews: some View {
        CreateArtifactView()
    }
}
