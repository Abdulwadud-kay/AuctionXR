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
                
                Spacer()
                
                // Watchlist button
                Button(action: { isWatchlisted.toggle() }) {
                    HStack {
                        Image(systemName: isWatchlisted ? "eye.fill" : "eye")
                        Text(isWatchlisted ? "Watchlisted" : "Watchlist")
                    }
                }
                .foregroundColor(isWatchlisted ? Color.blue : Color.primary)
                .padding(.bottom)
                
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

