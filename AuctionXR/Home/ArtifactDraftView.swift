import SwiftUI

struct RatingStarsView: View {
    var rating: Double

    var body: some View {
        HStack {
            ForEach(0..<5, id: \.self) { index in
                Image(systemName: index < Int(rating.rounded()) ? "star.fill" : "star")
                    .foregroundColor(.yellow)
            }
        }
        .padding(.all, 10)
        .cornerRadius(10)
        .frame(width: UIScreen.main.bounds.width / 2 - 20)
    }
}

struct ArtifactDraftView: View {
    @ObservedObject var viewModel: ArtifactsViewModel
    var artifact: ArtifactsData
    @State private var currentImageIndex = 0
    @State private var isDetailActive = false
    @State private var imageData: Data?
    let timer = Timer.publish(every: 900, on: .main, in: .common).autoconnect() // 900 seconds = 15 minutes
    
    var body: some View {
        NavigationView{
            VStack {
                NavigationLink(destination: ArtifactDetailView(viewModel: viewModel, artifact: artifact), isActive: $isDetailActive) {
                    EmptyView()
                }
                .hidden()
                
                Button(action: {
                    // Toggle the state to navigate to the details view when any image is tapped
                    self.isDetailActive.toggle()
                }) {
                    if let imageUrlString = artifact.imageUrls?[currentImageIndex],
                       let imageUrl = URL(string: imageUrlString),
                       let imageData = try? Data(contentsOf: imageUrl),
                       let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width / 2 - 30, height: 200)
                            .cornerRadius(10)
                            .shadow(color: .gray, radius: 4, x: 0, y: 2)
                    } else {
                        // Placeholder image or loading indicator
                        Color.gray
                            .frame(width: UIScreen.main.bounds.width / 2 - 30, height: 200)
                            .cornerRadius(10)
                            .shadow(color: .gray, radius: 4, x: 0, y: 2)
                    }
                }
                .onReceive(timer) { _ in
                    // Change the current image index every time the timer fires
                    self.currentImageIndex = (self.currentImageIndex + 1) % (artifact.imageUrls?.count ?? 0)
                    // Load image data asynchronously
                    if let imageUrlString = artifact.imageUrls?[currentImageIndex],
                       let imageUrl = URL(string: imageUrlString) {
                        self.loadImage(from: imageUrl)
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
            
        }
    }
            private func loadImage(from url: URL) {
                URLSession.shared.dataTask(with: url) { data, _, error in
                    if let data = data {
                        DispatchQueue.main.async {
                            self.imageData = data
                        }
                    }
                }.resume()
            }
        }

    
    // Preview
    //struct ArtifactDraftView_Previews: PreviewProvider {
    //    static var previews: some View {
    //        let viewModel = ArtifactsViewModel()
    //        let imageUrl = "data:image/jpeg;base64,/9j/4AAQSkZJRgABAQEAAAAAA..."
    //        let videoUrl = "https://www.example.com/sample-video.mp4"
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
    //            rating: 0.0,
    //            isBidded: false,
    //            bidEndDate: Date(),
    //            imageUrls: [imageUrl],
    //            videoUrl: [videoUrl],
    //            category: "Sample Category",
    //            timestamp: Date()
    //        )
    //
    //        return NavigationView {
    //            ArtifactDraftView(viewModel: viewModel, artifact: artifact)
    //                .environmentObject(viewModel)
    //        }
    //    }
    //}

