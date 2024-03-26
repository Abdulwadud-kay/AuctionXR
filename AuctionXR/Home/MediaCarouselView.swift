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
    var images: [UIImage]
    var videos: [String?] // Change type to String?
    var action: (Int, Bool) -> Void
    @State private var currentIndex: Int = 0

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomTrailing) {
                TabView(selection: $currentIndex) {
                    ForEach(0..<images.count, id: \.self) { index in
                        Image(uiImage: images[index])
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width)
                            .tag(index)
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
        }
        .frame(height: 300)
    }
}
