//
//  MediaCarouselView.swift
//  AuctionXR
//
//  Created by Abdulwadud Abdulkadir on 3/6/24.
//

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

struct MediaCarouselView: View {
    let images: [URL]
    let videos: [URL]
    @State private var currentIndex: Int = 0

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomTrailing) {
                TabView(selection: $currentIndex) {
                    ForEach(0..<images.count, id: \.self) { index in
                        Image(uiImage: UIImage(contentsOfFile: images[index].path)!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width)
                            .tag(index)
                    }
                    ForEach(0..<videos.count, id: \.self) { index in
                        VideoPlayerView(videoName: videos[index].lastPathComponent)
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
