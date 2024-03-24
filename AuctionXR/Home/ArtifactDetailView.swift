import SwiftUI
import FirebaseAuth

struct ArtifactDetailView: View {
    @ObservedObject var viewModel: ArtifactsViewModel
    var artifact: ArtifactsData
    @State private var showOptions = false
    @State private var isWatchlisted = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                MediaCarouselView(images: artifact.imageURLs, videos: artifact.videoURL ?? [], action: { _, _ in })


                    .frame(height: 300)
                    .cornerRadius(10)
                    .shadow(radius: 5)

                CountdownTimerView(endTime: artifact.bidEndDate)
                    .padding(.vertical)

                HStack {
                    Text(artifact.title)
                        .font(.headline)
                        .fontWeight(.bold)
                    Spacer()
                    Button(action: { showOptions = true }) {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.degrees(90))
                            .foregroundColor(.black)
                    }
                    .padding(.trailing, 10)
                }
                .padding(.top)

                Text(artifact.description)
                    .font(.subheadline)
                    .lineLimit(nil)

                HStack(spacing: 10) {
                    likeDislikeButton(imageName: "hand.thumbsup", count: artifact.likes?.count) {
                        viewModel.updateLike(for: artifact.id.uuidString, userID: "user123")
                    }

                    likeDislikeButton(imageName: "hand.thumbsdown", count: artifact.dislikes?.count) {
                        viewModel.updateDislike(for: artifact.id.uuidString, userID: "user124")
                    }
                    Spacer()
                    Button(action: { isWatchlisted.toggle() }) {
                        HStack {
                            Image(systemName: isWatchlisted ? "eye.fill" : "eye")
                            Text(isWatchlisted ? "Watchlisted" : "Watchlist")
                        }
                    }
                    .foregroundColor(isWatchlisted ? Color.blue : Color.primary)
                }
                .padding(.vertical)

                HStack {
                    ratingStars(rating: artifact.rating)
                    Spacer()
                    Button(action: {
                        // Fetch the currently authenticated user's username
                        guard let bidderUsername = Auth.auth().currentUser?.displayName else {
                            // Handle case when user is not authenticated or username is not available
                            return
                        }
                        
                        // Pass the artifactID and bidderUsername to the BidView
                        let bidView = BidView(viewModel: viewModel, artifact: artifact, currentBidder: bidderUsername, artifactID: artifact.id.uuidString)
                        // Present or navigate to the bidView
                    }) {
                    }
                        .buttonStyle(PrimaryButtonStyle())
                }
            }
            .padding()
        }
        .navigationBarTitle(Text(artifact.title), displayMode: .inline)
    }

    private func likeDislikeButton(imageName: String, count: Int?, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: imageName)
                if let count = count {
                    Text("\(count)")
                }
            }
        }
    }

    private func ratingStars(rating: Double) -> some View {
        HStack {
            ForEach(0..<5, id: \.self) { index in
                Image(systemName: index < Int(rating) ? "star.fill" : "star")
                    .foregroundColor(index < Int(rating) ? .yellow : .gray)
            }
        }
        .padding(.bottom)
    }
}


struct ArtifactDetailView_Previews: PreviewProvider {
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
        
        return NavigationView {
                    ArtifactDetailView(viewModel: viewModel, artifact: artifact)
                        .environmentObject(viewModel) // Pass the viewModel using environmentObject
                }
    }
}
