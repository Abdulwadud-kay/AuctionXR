import SwiftUI

struct ArtifactDetailView: View {
    @ObservedObject var viewModel: ArtifactsViewModel
    var artifact: ArtifactsData
    @State private var isWatchlisted = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let imageUrls = artifact.imageUrls, !imageUrls.isEmpty {
                    MediaCarouselView(images: imageUrls.compactMap { URL(string: $0) }, videos: artifact.videoUrl ?? []) { _, _ in }
                        .frame(height: 300)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                } else {
                    // Handle case where artifact has no image URLs or URLs are invalid
                    Text("No media available")
                        .foregroundColor(.secondary)
                        .padding()
                }

                

                CountdownTimerView(endTime: artifact.bidEndDate ?? Date())
                    .padding(.vertical)
                
                HStack {
                    Text(artifact.title)
                        .font(.headline)
                        .fontWeight(.bold)
                    Spacer()
                    Button(action: { /* Show options action */ }) {
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
                
                // Like, dislike, watchlist buttons
                HStack(spacing: 10) {
                    // Like button
                    likeDislikeButton(imageName: "hand.thumbsup", count: artifact.likes?.count) {
                        viewModel.updateLike(for: artifact.id.uuidString, userID: "user123")
                    }
                    
                    // Dislike button
                    likeDislikeButton(imageName: "hand.thumbsdown", count: artifact.dislikes?.count) {
                        viewModel.updateDislike(for: artifact.id.uuidString, userID: "user124")
                    }
                    
                    Spacer()
                    
                    // Watchlist button
                    Button(action: { isWatchlisted.toggle() }) {
                        HStack {
                            Image(systemName: isWatchlisted ? "eye.fill" : "eye")
                            Text(isWatchlisted ? "Watchlisted" : "Watchlist")
                        }
                    }
                    .foregroundColor(isWatchlisted ? Color.blue : Color.primary)
                }
                .padding(.vertical)
                
                // Rating stars
                HStack {
                    ratingStars(rating: artifact.rating)
                    Spacer()
                    
                    // Bid button
                    NavigationLink(destination: BidView(viewModel: viewModel, artifact: artifact)) {
                        Text("Bid")
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

//struct ArtifactDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        let viewModel = ArtifactsViewModel()
//        let imageUrl = "sample_image_url"
//        let videoUrl = "sample_video_url"
//        let artifact = ArtifactsData(
//            id: UUID(),
//            title: "Sample Artifact",
//            description: "This is a sample artifact",
//            startingPrice: 0.0,
//            currentBid: 100.0,
//            isSold: false,
//            likes: [],
//            dislikes: [],
//            currentBidder: "",
//            rating: 4.0,
//            isBidded: false,
//            bidEndDate: Date(),
//            imageUrls: [imageUrl],
//            videoUrl: [videoUrl],
//            category: "Sample Category",
//            timestamp: Date()
//        )
//        return NavigationView {
//            ArtifactDetailView(viewModel: viewModel, artifact: artifact)
//                .environmentObject(viewModel)
//        }
//    }
//}
