import SwiftUI

struct ArtifactSummaryView: View {
    @ObservedObject var viewModel: ArtifactsViewModel
    var artifact: ArtifactsData
    @State private var currentImageIndex = 0
    let timer = Timer.publish(every: 900, on: .main, in: .common).autoconnect() // 900 seconds = 15 minutes
    
    var body: some View {
        VStack {
            NavigationLink(destination: ArtifactDetailView(viewModel: viewModel, artifact: artifact)) {
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
            
            if let currentBid = artifact.currentBid {
                Text("Current Bid: $\(currentBid, specifier: "%.2f")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 2)
            } else {
                Text("Starting Price: $\(artifact.startingPrice, specifier: "%.2f")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 2)
            }
            
            // Display rating stars
            RatingStarsView(rating: artifact.rating)
                .padding(.all, 10)
                .cornerRadius(10)
                .frame(width: UIScreen.main.bounds.width / 2 - 20)
        }
        // Handle timer for image rotation
        .onReceive(timer) { _ in
            self.currentImageIndex = (self.currentImageIndex + 1) % (artifact.imageURLs.count > 0 ? artifact.imageURLs.count : 1)
        }

    }
}

struct ArtifactSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ArtifactsViewModel()
        let imageURL = URL(string: "https://example.com/video.jpg")!
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
            rating: 4.0,
            isBidded: false,
            bidEndDate: Date(),
            imageURLs: [],
            videoURL: [],
            category: "Sample Category",
            timestamp: Date() // Add the missing parameter
        )
        return ArtifactSummaryView(viewModel: viewModel, artifact: artifact)
            .previewLayout(.sizeThatFits)
            .padding()
           
    }
}
