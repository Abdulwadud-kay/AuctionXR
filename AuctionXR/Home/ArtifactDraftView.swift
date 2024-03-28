import SwiftUI

struct RatingStarsView: View {
    var rating: Double

    var body: some View {
        HStack {
            ForEach(0..<5, id: \.self) { index in
                Image(systemName: index < Int(rating.rounded()) ? "star.fill" : "star")
                    .foregroundColor(.yellow)
            }
        }
        .padding(.all, 10)
        .cornerRadius(10)
        .frame(width: UIScreen.main.bounds.width / 2 - 20)
    }
}

struct ArtifactDraftView: View {
    @ObservedObject var viewModel: ArtifactsViewModel
    var artifact: ArtifactsData
    @State private var currentImageIndex = 0
    @State private var isDetailActive = false
    @State private var imageData: Data?
    @State private var isDeleteConfirmationShown = false
    
    let timer = Timer.publish(every: 900, on: .main, in: .common).autoconnect() // 900 seconds = 15 minutes
    
    var body: some View {
          
        VStack {
            if let imageUrlString = artifact.imageUrls?[currentImageIndex],
               let imageUrl = URL(string: imageUrlString),
               let imageData = try? Data(contentsOf: imageUrl),
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipped()
                    .frame(width: 150, height: 150)
                    .cornerRadius(10)
            
            } else {
 
                Color.gray
                    .frame(width: 150, height: 150)
                    .cornerRadius(10)

            }
            
            Text(artifact.title)
                .font(.title2)
                .padding(.top, 10)
                .foregroundColor(.black)
            
            Text("Starting Price: $\(artifact.startingPrice, specifier: "%.2f")")
                .font(.headline)
                .padding(.top, 2)
                .foregroundColor(.black)
            
            
            // Display rating stars
            RatingStarsView(rating: artifact.rating)
                .padding(.all, 10)
                .cornerRadius(10)
                .frame(width: UIScreen.main.bounds.width / 2 - 20)
        }
        .gesture(LongPressGesture(minimumDuration: 1.0)
            .onEnded { _ in
                // Show delete confirmation
                self.isDeleteConfirmationShown.toggle()
            }
        )
        .overlay(
            VStack {
                Spacer()
                if isDeleteConfirmationShown {
                    HStack {
                        Spacer()
                        Button(action: {
                            self.viewModel.removeArtifactFromDrafts(artifactID: artifact.id.uuidString)
                            
                            // Dismiss the confirmation
                            self.isDeleteConfirmationShown.toggle()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
                }
            }
        )
    }
      
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                DispatchQueue.main.async {
                    self.imageData = data
                }
            }
        }.resume()
    }

}

    
struct ArtifactDraftView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ArtifactsViewModel()
        let imageUrl = "ArtifactImage.jpg"
        let videoUrl = "https://www.example.com/sample-video.mp4"
        
        // Convert UUID to String
        let artifactID = UUID().uuidString
        
        // Create a dictionary representing the data that would be fetched from Firestore
        let data: [String: Any] = [
            "title": "Sample Artifact",
            "description": "This is a sample artifact",
            "startingPrice": 0.0,
            "currentBid": 100.0,
            "isSold": false,
            "currentBidder": "",
            "rating": 0.0,
            "isBidded": false,
            "bidEndDate": Date(),
            "imageUrls": [imageUrl],
            "videoUrl": [videoUrl],
            "category": "Sample Category",
            "timestamp": Date(),
            "userID": "sampleUserID"
        ]
        
        // Initialize ArtifactsData using the provided data dictionary
        guard let artifact = ArtifactsData(id: artifactID, data: data) else {
            fatalError("Failed to initialize ArtifactsData")
        }
        
        return NavigationView {
            ArtifactDraftView(viewModel: viewModel, artifact: artifact)
                .environmentObject(viewModel)
        }
    }
}
