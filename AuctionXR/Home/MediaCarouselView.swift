import SwiftUI
import AVKit
import AVFoundation

// Define your media types
enum MediaType {
    case photo, video
}

// VideoPlayerView that plays a video from the app bundle
struct VideoPlayerView: View {
    var videoURLString: String
    
    var player: AVPlayer {
        return AVPlayer(playerItem: AVPlayerItem(url: URL(string: videoURLString)!))
    }
    
    var body: some View {
        VideoPlayer(player: player)
            .onAppear {
                player.play()
            }
            .onDisappear {
                player.pause()
            }
    }
}

struct MediaCarouselView: View {
    var images: [URL]
    var videos: [String?] // Change type to String?
    var action: (Int, Bool) -> Void
    @State private var currentIndex: Int = 0

    var body: some View {
        GeometryReader { geometry in
            if !images.isEmpty {
                ZStack(alignment: .bottomTrailing) {
                    TabView(selection: $currentIndex) {
                        ForEach(0..<images.count, id: \.self) { index in
                            // Load image asynchronously from URL
                            AsyncImage(url: images[index]) { phase in
                                switch phase {
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: geometry.size.width)
                                            .tag(index)
                                    case .empty:
                                        Text("Loading...")
                                    case .failure:
                                        Text("Failed to load image")
                                }
                            }
                        }
                        ForEach(0..<videos.count, id: \.self) { index in
                            if let videoURLString = videos[index] {
                                VideoPlayerView(videoURLString: videoURLString) // Pass video URL string
                                    .frame(width: geometry.size.width)
                                    .tag(images.count + index)
                            }
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                }
                .frame(height: 300)
            } else {
                Text("No media available")
                    .foregroundColor(.secondary)
                    .padding()
            }
        }
        .frame(height: 300)
    }
}
