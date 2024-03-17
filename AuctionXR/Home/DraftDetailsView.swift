import SwiftUI

struct DraftDetailsView: View {
    @ObservedObject var viewModel: ArtifactsViewModel
    @State private var isEditing = false
    @State private var editedTitle: String = ""
    @State private var editedDescription: String = ""
    @State private var editedStartingPrice: Double = 0.0
    @State private var editedBidEndTime: Date = Date()
    @State private var selectedCategory: String = ""
    @State private var showDeleteConfirmation = false
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var showVideoPicker = false
    @State private var selectedVideoURL: URL?
    @State private var editedImageURLs: [URL] = []
    @State private var editedVideoURL: URL?
    
    
    var artifact: ArtifactsData

    init(viewModel: ArtifactsViewModel, artifact: ArtifactsData) {
            self.viewModel = viewModel
            self.artifact = artifact
            self._editedTitle = State(initialValue: artifact.title)
            self._editedDescription = State(initialValue: artifact.description)
            self._editedStartingPrice = State(initialValue: artifact.startingPrice)
            self._editedBidEndTime = State(initialValue: artifact.bidEndDate)
            self._selectedCategory = State(initialValue: artifact.category)
            self._editedImageURLs = State(initialValue: artifact.imageURLs.compactMap { $0 })
            self._editedVideoURL = State(initialValue: artifact.videoURL)
        }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                MediaCarouselView(images: editedImageURLs, videos: [editedVideoURL].compactMap { $0 })
                    .frame(height: 300)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .onTapGesture {
                        isEditing ? showImagePicker.toggle() : ()
                    }
                
                HStack {
                    TextField("Title", text: $editedTitle)
                        .font(.headline)
                        .fontWeight(.bold)
                    Spacer()
                    Button(action: {
                        showDeleteConfirmation = true
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                    .padding(.trailing, 10)
                }
                .padding(.top)
                
                HStack {
                    Text("Starting Price:")
                        .font(.headline)
                    TextField("Starting Price", value: $editedStartingPrice, formatter: NumberFormatter())
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                        .disabled(!isEditing)
                }
                .padding(.horizontal)
                .padding(.top)
                
                if isEditing {
                    HStack {
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
                    }
                }
                
                if isEditing {
                    DatePicker("Bid End Time", selection: $editedBidEndTime, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                        .padding(.top)
                } else {
                    Text("Bid End Time: \(formattedBidEndTime())")
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                        .padding(.top)
                }

                TextField("Description", text: $editedDescription)
                    .font(.subheadline)
                    .padding(.horizontal)
                    .padding(.vertical)
                    .lineLimit(nil)
                    .disabled(!isEditing)

                HStack {
                    ratingStars(rating: artifact.rating)
                    Spacer()
                    Button(isEditing ? "Save" : "Edit") {
                        isEditing.toggle()
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    Button("Post") {
                        updateArtifact()
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
                .padding(.bottom)
            }
            .padding(.horizontal)
        }
        .navigationBarTitle(Text(artifact.title), displayMode: .inline)
        .alert(isPresented: $showDeleteConfirmation) {
            Alert(
                title: Text("Delete Artifact"),
                message: Text("Are you sure you want to delete this artifact?"),
                primaryButton: .destructive(Text("Delete")) {
                    // Implement delete functionality
                },
                secondaryButton: .cancel()
            )
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
        .sheet(isPresented: $showVideoPicker) {
            VideoPicker(selectedVideoURL: $selectedVideoURL)
        }
    }

    private func ratingStars(rating: Double) -> some View {
        HStack {
            ForEach(0..<5, id: \.self) { index in
                Image(systemName: index < Int(rating) ? "star.fill" : "star")
                    .foregroundColor(index < Int(rating) ? .yellow : .gray)
            }
        }
    }

    private func formattedBidEndTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        return dateFormatter.string(from: editedBidEndTime)
    }

    private func updateArtifact() {
        var updatedArtifact = artifact
        updatedArtifact.title = editedTitle
        updatedArtifact.description = editedDescription
        updatedArtifact.startingPrice = editedStartingPrice
        updatedArtifact.bidEndDate = editedBidEndTime
        updatedArtifact.category = selectedCategory
        updatedArtifact.imageURLs = editedImageURLs
        updatedArtifact.videoURL = [editedVideoURL].compactMap { $0 }

        viewModel.updateArtifact(updatedArtifact)
    }
}

struct DraftDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ArtifactsViewModel()
        let imageURL = URL(string: "https://example.com/image.jpg")!
        let videoURL = URL(string: "https://example.com/video.mp4")!
        let artifact = ArtifactsData(
            id: UUID(),
            title: "Sample Artifact",
            description: "This is a sample artifact",
            startingPrice: 0.0,
            currentBid: 100.0,
            isSold: false,
            likes: [],
            dislikes: [],
            currentBidder: "",
            rating: 0.0,
            isBidded: false,
            bidEndDate: Date(),
            imageURLs: [imageURL],
            videoURL: videoURL,
            category: "Sample Category",
            timestamp: Date()
        )
        return DraftDetailsView(viewModel: viewModel, artifact: artifact)
    }
}
