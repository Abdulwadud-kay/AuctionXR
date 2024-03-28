import SwiftUI
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
    @State private var showVideoPicker: Bool = false
    @State private var bidEndDate: Date = Date()
    @State private var minBidEndDate: Date = Date().addingTimeInterval(30 * 60)
    @State private var maxBidEndDate: Date = Calendar.current.date(byAdding: .year, value: 2, to: Date())!
    @State private var isSaveBlinking = false
    @State private var isBlinking = false
    @State private var showImagePicker: Bool = false
    @Binding var isShowingCreateArtifactView: Bool
    @State private var pickerPresented = false
    @StateObject var artifactsViewModel: ArtifactsViewModel
    
    let userId: String // 2 years from now
    
    
    let defaultCurrentBid: Double? = 0.0
    let defaultIsSold: Bool = false
    let defaultCurrentBidder: String = ""
    let defaultRating: Double = 0.0
    let defaultIsBidded: Bool = false
    let defaultTimestamp: Date? = nil
    
    let minBidDuration: TimeInterval = 30 * 60 // 30 minutes in seconds
    let maxBidDuration: TimeInterval = 2 * 365 * 24 * 60 * 60 // 2 years in seconds
    let bidEndDateRange: ClosedRange<Date> = Date()...(Date() + 2 * 365 * 24 * 60 * 60) // From now to 2 years in the future
    
    let backgroundColor = Color(hex:"#5729CE") // Ensure you have a method to initialize Color with hex.
    let  iconColor = Color(.white)
    let gradientTop = Color(.white)
    let gradientBottom = Color.white
    
    var body: some View {
        ScrollView (showsIndicators: false){
            VStack(alignment: .leading, spacing: 20) {
                Spacer(minLength: 10)
                TextField("Name of Artifact", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .shadow(color: .gray, radius: 2, x: 0, y: 2)
                
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
                        .foregroundColor(.black) // Placeholder text color
                        .shadow(color: .gray, radius: 2, x: 0, y: 2) // Apply shadow
                }
                
                TextField("Starting Price", text: $startingPrice)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .shadow(color: .gray, radius: 2, x: 0, y: 2)
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
                
                Text("Category")
                    .padding(.horizontal)
                Picker("Category", selection: $selectedCategory) {
                    Text("Art").tag("Art")
                    Text("Collections").tag("Collections")
                    Text("Science").tag("Science")
                    Text("Special").tag("Special")
                }
                .pickerStyle(MenuPickerStyle())
                .padding(.horizontal)
                .foregroundColor(.black)
                
                Toggle("Accept Terms & Conditions", isOn: $acceptTerms)
                    .padding(.horizontal)
                
                HStack(spacing: 30) { // Adjust spacing as needed
                    Button(action: {
                        pickerPresented = true
                    }) {
                        VStack {
                            Image(systemName: "camera.fill")
                                .font(.title)
                                .foregroundColor(.white)
                                .shadow(color: .gray, radius: 2, x: 0, y: 2)
                                
                            Text("")
                                .foregroundColor(backgroundColor )
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
                                .shadow(color: .gray, radius: 2, x: 0, y: 2)
                                .padding(.leading, 240)
                            Text("")
                                .foregroundColor(backgroundColor )
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
                HStack(spacing: 20) {
                    Text("Save for Later")
                        .font(.subheadline)
                        .foregroundColor(isSaveBlinking ? .white : Color(backgroundColor))
                        .onTapGesture {
                            isSaveBlinking.toggle()
                            saveDraft()
                        }
                    
                    Button("Submit") {
                        submitArtifact()
                    }
                    .disabled(!isFormComplete)
                    .padding()
                    .frame(width: 100, height: 40)
                    .background(isFormComplete ? Color(#colorLiteral(red: 0.3411764706, green: 0.1607843137, blue: 0.8078431373, alpha: 1)) : Color.gray)
                    .cornerRadius(25)
                    .foregroundColor(.white)
                    .opacity(isBlinking ? 0.0 : 1.0)
                    .padding(.leading, 120)
                }
                .padding([.horizontal, .bottom])
                .padding(.top, -10)
                .padding(.horizontal, 10) // Add horizontal padding

            }
            .background(LinearGradient(gradient: Gradient(colors: [gradientTop, gradientBottom]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
            .sheet(isPresented: $pickerPresented) {
                PHPickerViewControllerWrapper(selectedImages: $selectedImages, isPresented: $pickerPresented)
            }
            
            .sheet(isPresented: $showVideoPicker) {
                VideoPicker(selectedVideoURL: $selectedVideoURL)
            }
        }
    }
    
    private var isFormComplete: Bool {
        !title.isEmpty && !description.isEmpty && !startingPrice.isEmpty && selectedCategory != "Select Category" && acceptTerms && (!selectedImages.isEmpty)
    }
    private func saveDraft() {
        
        guard let startingPriceDouble = Double(startingPrice) else {
                print("Invalid starting price")
                // Inform the user about the error, e.g., show an alert
                return
            }

        uploadMedia(images: selectedImages, videos: selectedVideoURL != nil ? [selectedVideoURL!] : []) { imageURLs, videoURL in
            let draftData: [String: Any] = [
                "id": UUID().uuidString,
                "title": self.title,
                "description": self.description,
                "startingPrice": startingPriceDouble,
                "currentBid": defaultCurrentBid as Any,
                "isSold": defaultIsSold,
                "currentBidder": defaultCurrentBidder,
                "rating": defaultRating,
                "isBidded": defaultIsBidded,
                "bidEndDate": Timestamp(date: Calendar.current.startOfDay(for: self.bidEndDate)),

                "imageUrls": imageURLs,
                "videoUrl": videoURL,
                "category": self.selectedCategory,
                "userID": self.userId,
                "timestamp": FieldValue.serverTimestamp()            ]
            
            let db = Firestore.firestore()
                    db.collection("users").document(self.userId).collection("drafts").addDocument(data: draftData) { error in
                        if let error = error {
                            print("Error saving draft: \(error.localizedDescription)")
                            // Inform the user about the error, e.g., show an alert
                        } else {
                            print("Draft saved successfully")
                            // Provide feedback to the user, e.g., display a success message
                            withAnimation(.easeInOut(duration: 0.5).repeatCount(3, autoreverses: true)) {
                                isBlinking = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                isBlinking = false
                                isShowingCreateArtifactView = false // Dismiss the view here
                            }
                        }
                    }
                }
            }

    private func submitArtifact() {
        guard isFormComplete else {
            print("Form is incomplete")
            // Inform the user that the form is incomplete
            return
        }
        guard let startingPriceDouble = Double(startingPrice) else {
                print("Invalid starting price")
                // Inform the user about the error, e.g., show an alert
                return
            }

        uploadMedia(images: selectedImages, videos: selectedVideoURL != nil ? [selectedVideoURL!] : []) { imageURLs, videoURL in
            let artifactData: [String: Any] = [
                "id": UUID().uuidString,
                "title": self.title,
                "description": self.description,
                "startingPrice": startingPriceDouble,
                "currentBid": defaultCurrentBid as Any,
                "isSold": defaultIsSold,
                "currentBidder": defaultCurrentBidder,
                "rating": defaultRating,
                "isBidded": defaultIsBidded,
                "bidEndDate": Timestamp(date: Calendar.current.startOfDay(for: self.bidEndDate)),

                "imageUrls": imageURLs,
                "videoUrl": videoURL,
                "category": self.selectedCategory,
                "userID": self.userId,
                "timestamp": FieldValue.serverTimestamp()
            ]
            let db = Firestore.firestore()
            let artifactRef = db.collection("users").document(self.userId).collection("posts").document() // Generate a new document ID
            
            artifactRef.setData(artifactData) { error in
                if let error = error {
                    print("Error submitting artifact: \(error.localizedDescription)")
                    // Inform the user about the error, e.g., show an alert
                } else {
                    print("Artifact submitted successfully")
                    // Provide feedback to the user, e.g., display a success message
                    withAnimation(.easeInOut(duration: 0.5).repeatCount(3, autoreverses: true)) {
                        isBlinking = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        isBlinking = false
                        isShowingCreateArtifactView = false // Dismiss the view here
                    }
                }
            }
        }
    }
    
    
    
    
    func uploadMedia(images: [UIImage], videos: [URL], completion: @escaping ([String], [String]) -> Void) {
        let storage = Storage.storage()
        let dispatchGroup = DispatchGroup()
        var imageUrls: [String] = []
        var videoUrls: [String] = []
        
        for image in images {
            dispatchGroup.enter()
            let imageName = UUID().uuidString + ".jpg"
            let imageRef = storage.reference().child("images/\(imageName)")
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                dispatchGroup.leave()
                continue
            }
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            imageRef.putData(imageData, metadata: metadata) { (_, error) in
                if let error = error {
                    print("Error uploading image: \(error.localizedDescription)")
                } else {
                    imageRef.downloadURL { (url, error) in
                        if let imageUrl = url?.absoluteString {
                            imageUrls.append(imageUrl)
                        }
                        dispatchGroup.leave()
                    }
                }
            }
        }
        
        for video in videos {
            dispatchGroup.enter()
            let videoName = UUID().uuidString + ".mp4"
            let videoRef = storage.reference().child("videos/\(videoName)")
            do {
                let videoData = try Data(contentsOf: video)
                let metadata = StorageMetadata()
                metadata.contentType = "video/mp4"
                videoRef.putData(videoData, metadata: metadata) { (_, error) in
                    if let error = error {
                        print("Error uploading video: \(error.localizedDescription)")
                    } else {
                        videoRef.downloadURL { (url, error) in
                            if let videoUrl = url?.absoluteString {
                                videoUrls.append(videoUrl)
                            }
                            dispatchGroup.leave()
                        }
                    }
                }
            } catch {
                print("Error loading video data: \(error.localizedDescription)")
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(imageUrls, videoUrls)
        }
    }
}


struct CreateArtifactView_Previews: PreviewProvider {
    static var previews: some View {
        let userAuthManager = UserManager()
        // Assuming that isShowingCreateArtifactView is a Binding<Bool> and it should be the first argument
        CreateArtifactView(isShowingCreateArtifactView: .constant(true), artifactsViewModel: ArtifactsViewModel(), userId: userAuthManager.userId)
    }
}


