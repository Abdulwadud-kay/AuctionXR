

import SwiftUI
import AVKit
import AVFoundation

// Define your media types
enum MediaType {
    case photo, video
}

// VideoPlayerView that plays a video from the app bundle
struct VideoPlayerView: View {
    var videoName: String
    
    var player: AVPlayer {
        guard let url = videoURL else {
            fatalError("Video \(videoName) not found")
        }
        return AVPlayer(url: url)
    }
    
    var videoURL: URL? {
        let fileExtensions = ["mp4", "mov", "avi", "mkv"] // Add more file extensions if needed
        
        for ext in fileExtensions {
            if let path = Bundle.main.path(forResource: videoName, ofType: ext) {
                return URL(fileURLWithPath: path)
            }
        }
        
        print("Video \(videoName) not found")
        return nil
    }

    var body: some View {
        if let videoURL = videoURL {
            VideoPlayer(player: player)
                .onAppear {
                    player.play()
                }
                .onDisappear {
                    player.pause()
                }
        } else {
            Text("Video not found")
        }
    }
}


// Helper View for Icon and Text
struct IconText: View {
    let imageName: String
    let text: String

    var body: some View {
        HStack {
            Image(systemName: imageName)
            Text(text)
        }
    }
}
// MediaCarouselView that handles both images and videos
struct MediaCarouselView: View {
    let images: [String]
    let videos: [String]
    @State private var currentIndex: Int = 0

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomTrailing) {
                TabView(selection: $currentIndex) {
                    ForEach(0..<images.count, id: \.self) { index in
                        Image(images[index])
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width)
                            .tag(index)
                    }
                    ForEach(0..<videos.count, id: \.self) { index in
                        VideoPlayerView(videoName: videos[index])
                            .frame(width: geometry.size.width)
                            .tag(images.count + index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
        }
        .frame(height: 300)
    }
}



struct ArtifactDetailView: View {
    @ObservedObject var viewModel: ArtifactsViewModel
    var artifact: ArtifactsData
    @State private var showOptions = false
    @State private var isWatchlisted = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                MediaCarouselView(images: artifact.imageNames, videos: artifact.videoNames)
                    .frame(height: 300)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                CountdownTimerView(endTime: artifact.bidEndTime)
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
                    .actionSheet(isPresented: $showOptions) {
                        ActionSheet(
                            title: Text("Options"),
                            buttons: [
                                .default(Text("Download")), // Replace with actual actions
                                .cancel()
                            ]
                        )
                    }
                }
                .padding(.top)

                Text(artifact.description)
                    .font(.subheadline)
                    .padding(.vertical)
                    .lineLimit(nil)

                HStack(spacing: 10) {
                    likeDislikeButton(imageName: "hand.thumbsup", count: artifact.likes) {
                        viewModel.updateLikes(for: artifact.id)
                    }
                    likeDislikeButton(imageName: "hand.thumbsdown", count: artifact.dislikes) {
                        viewModel.updateDislikes(for: artifact.id)
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

                HStack {
                    ratingStars(rating: viewModel.calculateRating(for: artifact))
                    Spacer()
                    Button("Bid") {
                        // Implement Bid Action
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
                .padding(.bottom)
            }
            .padding(.horizontal)
        }
        .navigationBarTitle(Text(artifact.title), displayMode: .inline)
    }

    private func likeDislikeButton(imageName: String, count: Int, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: imageName)
                Text("\(count)")
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
    }
}

struct ArtifactDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let oneDayIntoFuture = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        ArtifactDetailView(viewModel: ArtifactsViewModel(), artifact: ArtifactsData(title: "Sample Artifact", description: "This is a detailed description of the artifact.", startingPrice: 100, currentBid: 150, isSold: false, likes: 10, dislikes: 5, currentBidder: "John Doe", timeRemaining: 3600, comments: 3, imageName: "sampleImage", rating: 4.5, isBidded: false,bidEndTime: oneDayIntoFuture, imageNames: ["ArtifactImage", "ArtifactImage"], videoNames: ["vid"]))
    }
}
