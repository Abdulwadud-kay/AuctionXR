//
//  ArtifactSummaryView.swift
//  GoTwice
//
//  Created by Abdulwadud Abdulkadir on 1/8/24.
//

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
                ZStack(alignment: .bottomTrailing) {
                    // Using AsyncImage to load an image from a URL
                    if let url = artifact.imageURLs[currentImageIndex] {
                        AsyncImage(url: url) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width / 2 - 30, height: 200)
                        .cornerRadius(10)
                        .shadow(color: .gray, radius: 4, x: 0, y: 2)
                        
                        CountdownTimerView(endTime: artifact.bidEndDate)
                            .padding([.bottom, .trailing], 10)
                    } else {
                        Text("Error loading image")
                            .foregroundColor(.red)
                            .frame(width: UIScreen.main.bounds.width / 2 - 30, height: 200)
                            .cornerRadius(10)
                            .shadow(color: .gray, radius: 4, x: 0, y: 2)
                    }
                }
            }
            
            Text(artifact.title)
                .font(.headline)
                .fontWeight(.bold)
                .padding(.top, 2)
            
            Text("Current Bid: $\(artifact.currentBid, specifier: "%.2f")")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.bottom, 2)
            
            HStack {
                ForEach(0..<Int(artifact.rating.rounded()), id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }
            }
            .padding(.all, 10)
            .cornerRadius(10)
            .frame(width: UIScreen.main.bounds.width / 2 - 20)
        }
        .onReceive(timer) { _ in
            self.currentImageIndex = (self.currentImageIndex + 1) % (artifact.imageURLs.count > 0 ? artifact.imageURLs.count : 1)
        }
    }
}







struct ArtifactSummaryView_Previews: PreviewProvider {
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
        return ArtifactSummaryView(viewModel: viewModel, artifact: artifact)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
