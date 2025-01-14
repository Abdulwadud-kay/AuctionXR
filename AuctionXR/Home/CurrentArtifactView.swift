import SwiftUI

struct CurrentArtifactView: View {
    @ObservedObject var viewModel: ArtifactsViewModel
    var artifact: ArtifactsData
    @State private var currentImageIndex = 0
    @State private var isDetailActive = false
    @State private var imageData: Data?
    
    let timer = Timer.publish(every: 15, on: .main, in: .common).autoconnect() // Change image every 15 seconds
    
    var body: some View {
        VStack {
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
            
            // Display current bidder and bid end time
            HStack {
                if let currentBidder = artifact.currentBidder, !currentBidder.isEmpty {
                    Text("Current Bidder: \(currentBidder)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 2)
                }
                Spacer()
                
                    if let bidEndDate = artifact.bidEndDate {
                        Text("Bid Ends: \(formattedDate(from: bidEndDate))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.bottom, 2)
                    } else {
                        Text("Bid Ends: N/A")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.bottom, 2)
                    }
                }


            // Display rating stars
            RatingStarsView(rating: artifact.rating)
                .padding(.all, 10)
                .cornerRadius(10)
                .frame(width: UIScreen.main.bounds.width / 2 - 20)
        }
        .animation(.easeInOut) // Add animation
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
    
    private func formattedDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
