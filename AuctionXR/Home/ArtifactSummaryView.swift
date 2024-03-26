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
                self.currentImageIndex = (self.currentImageIndex + 1) % artifact.imageUrls.count
            }) {
                // Display artifact image with Image
                Image(uiImage: UIImage(data: Data(base64Encoded: artifact.imageUrls[currentImageIndex]) ?? Data()) ?? UIImage()) // Convert base64 string to Data, then to UIImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width / 2 - 30, height: 200)
                    .cornerRadius(10)
                    .shadow(color: .gray, radius: 4, x: 0, y: 2)
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
            self.currentImageIndex = (self.currentImageIndex + 1) % (artifact.imageUrls.count > 0 ? artifact.imageUrls.count : 1)
        }
    }
}

struct ArtifactSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ArtifactsViewModel()
        let imageUrl = "sample_image_url"
        let videoUrl = "sample_video_url"
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
            imageUrls: [imageUrl],
            videoUrl: [videoUrl],
            category: "Sample Category",
            timestamp: Date()
        )
        return ArtifactSummaryView(viewModel: viewModel, artifact: artifact)
            .padding()
    }
}
