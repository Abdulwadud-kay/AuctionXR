


import SwiftUI

struct DraftDetailsView: View {
    @ObservedObject var viewModel: ArtifactsViewModel
    var artifact: ArtifactsData
    
    @State private var editedTitle: String
    @State private var editedDescription: String
    @State private var editedStartingPrice: Double
    @State private var editedBidEndTime: Date
    @State private var selectedCategory: String
    @State private var isEditing = false
    @State private var showDeleteConfirmation = false
    @State private var selectedImageIndex: Int?
    @State private var showImagePicker = false
    @State private var showVideoPicker = false
    @State private var selectedImageURL: UIImage?
    @State private var selectedVideoURL: URL?
    
    init(viewModel: ArtifactsViewModel, artifact: ArtifactsData) {
        self.viewModel = viewModel
        self.artifact = artifact
        
        // Initialize state variables with original artifact details
        self._editedTitle = State(initialValue: artifact.title)
        self._editedDescription = State(initialValue: artifact.description)
        self._editedStartingPrice = State(initialValue: artifact.startingPrice)
        self._editedBidEndTime = State(initialValue: artifact.bidEndDate)
        self._selectedCategory = State(initialValue: artifact.category)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if !artifact.imageUrls.isEmpty,
                   let imageUrl = artifact.imageUrls.first, // Take the first image URL
                   let uiImage = UIImage(data: Data(base64Encoded: imageUrl) ?? Data()) {
                    MediaCarouselView(images: [uiImage], videos: artifact.videoUrl ?? []) { _, _ in }
                        .frame(height: 300)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                } else {
                    // Handle case where artifact has no image URLs
                    Text("No media available")
                        .foregroundColor(.secondary)
                        .padding()
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
                    if isEditing {
                        Button("Save") {
                            updateArtifact()
                            isEditing.toggle()
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        Button("Cancel") {
                            resetEditedDetails()
                            isEditing.toggle()
                        }
                        .buttonStyle(SecondaryButtonStyle())
                    } else {
                        Button("Edit") {
                            isEditing.toggle()
                        }
                        .buttonStyle(PrimaryButtonStyle())
                    }
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
            ImagePicker(selectedImage: self.$selectedImageURL, sourceType: .photoLibrary) { _ in }
        }


                .sheet(isPresented: $showVideoPicker) {
                    VideoPicker(selectedVideoURL: self.$selectedVideoURL)
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
        let updatedArtifact = ArtifactsData(
            id: artifact.id,
            title: editedTitle,
            description: editedDescription,
            startingPrice: editedStartingPrice,
            currentBid: artifact.currentBid,
            isSold: artifact.isSold,
            likes: artifact.likes,
            dislikes: artifact.dislikes,
            currentBidder: artifact.currentBidder,
            rating: artifact.rating,
            isBidded: artifact.isBidded,
            bidEndDate: editedBidEndTime,
            imageUrls: artifact.imageUrls,
            videoUrl: artifact.videoUrl,
            category: selectedCategory,
            timestamp: artifact.timestamp
        )
        
        viewModel.updateArtifact([updatedArtifact])
    }

    private func resetEditedDetails() {
        editedTitle = artifact.title
        editedDescription = artifact.description
        editedStartingPrice = artifact.startingPrice
        editedBidEndTime = artifact.bidEndDate
        selectedCategory = artifact.category
    }
}
struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
            .foregroundColor(Color.white)
            .background(Color.blue)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed) // Use animation(_:value:)
    }
}


struct DraftDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ArtifactsViewModel()
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
            rating: 4.0,
            isBidded: false,
            bidEndDate: Date(),
            imageUrls: [],
            videoUrl: [],
            category: "Sample Category",
            timestamp: Date()
        )
        return DraftDetailsView(viewModel: viewModel, artifact: artifact)
            
    }
}
