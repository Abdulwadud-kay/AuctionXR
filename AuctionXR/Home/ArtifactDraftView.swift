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
    @State private var image: Image?
    let timer = Timer.publish(every: 900, on: .main, in: .common).autoconnect() // 900 seconds = 15 minutes
    
    var body: some View {
        VStack {
            NavigationLink(destination: DraftDetailsView(viewModel: viewModel, artifact: artifact)) {
                EmptyView()
            }
            .hidden()
            
            Button(action: {
                self.currentImageIndex = (self.currentImageIndex + 1) % artifact.imageURLs.count
            }) {
                // Display artifact image with AsyncImage
                AsyncImage(url: artifact.imageURLs[currentImageIndex]) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width / 2 - 30, height: 200)
                        .cornerRadius(10)
                        .shadow(color: .gray, radius: 4, x: 0, y: 2)
                } placeholder: {
                    ProgressView()
                }

            }
            
            Text(artifact.title)
                .font(.headline)
                .fontWeight(.bold)
                .padding(.top, 2)
            
            Text("Starting Price: $\(artifact.startingPrice, specifier: "%.2f")")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.bottom, 2)
            
            // Display rating stars
            RatingStarsView(rating: artifact.rating)
        }
        // Handle timer for image rotation
        .onReceive(timer) { _ in
            self.currentImageIndex = (self.currentImageIndex + 1) % (artifact.imageURLs.count > 0 ? artifact.imageURLs.count : 1)
        }

    }
}

// Preview
struct ArtifactDraftView_Previews: PreviewProvider {
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
            videoURL: [videoURL],
            category: "Sample Category",
            timestamp: Date() // Add the missing parameter
        )
        return ArtifactDraftView(viewModel: viewModel, artifact: artifact)
    }
}
