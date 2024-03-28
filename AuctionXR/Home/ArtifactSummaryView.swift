import SwiftUI

struct ArtifactSummaryView: View {
    @ObservedObject var viewModel: ArtifactsViewModel
    var artifact: ArtifactsData
    @State private var currentImageIndex = 0
    @State private var isDetailActive = false
    @State private var imageData: Data?
    
    let timer = Timer.publish(every: 15, on: .main, in: .common).autoconnect() // Change image every 15 seconds
    
    var body: some View {
//        ZStack {
//            // Shaded rectangle behind the entire artifact
//            RoundedRectangle(cornerRadius: 10)
//                .fill(Color.white) // Adjust the opacity as needed
//                .frame(width: 170, height: 300) // Adjust size as needed
//                .shadow(color: Color.black, radius:2)
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
                            .aspectRatio(contentMode: .fit)
                            .clipped()
                            .frame(width: 150, height: 150)
                            .cornerRadius(10)
//                            .shadow(color: .gray, radius: 4)
                    } else {
                        // Placeholder image or loading indicator
                        Color.gray
                            .frame(width: 150, height: 150)
                            .cornerRadius(10)
//                            .shadow(color: .gray, radius: 4)
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
                    .font(.title2)
                    .padding(.top, 10)
                    .foregroundColor(.black)
                
                if let currentBid = artifact.currentBid {
                    Text("Current Bid: $\(currentBid, specifier: "%.2f")")
                        .font(.headline)
                        .padding(.top, 2)
                        .foregroundColor(.black)
                } else {
                    Text("Starting Price: $\(artifact.startingPrice, specifier: "%.2f")")
                        .font(.headline)
                        .padding(.top, 2)
                        .foregroundColor(.black)
                }
                
                // Display rating stars
                RatingStarsView(rating: artifact.rating)
                    .padding(.all, 10)
                    .cornerRadius(10)
                    .frame(width: UIScreen.main.bounds.width / 2 - 20)
            }
         
        }
     

//    }
    
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

