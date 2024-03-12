import SwiftUI

struct ArtifactDraftView: View {
    @ObservedObject var viewModel: ArtifactsViewModel
    var artifact: ArtifactsData
    @State private var currentImageIndex = 0
    @State private var image: Image?
    let timer = Timer.publish(every: 900, on: .main, in: .common).autoconnect() // 900 seconds = 15 minutes
    
    var body: some View {
        VStack {
            NavigationLink(destination: DraftDetailsView(viewModel: viewModel, artifact: artifact)) {
                EmptyView()
            }
            .hidden()
            
            Button(action: {
                self.currentImageIndex = (self.currentImageIndex + 1) % artifact.imageURLs.count
                self.loadImage(from: artifact.imageURLs[currentImageIndex])
            }) {
                if let image = image {
                    ZStack(alignment: .bottomTrailing) {
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width / 2 - 30, height: 200)
                            .cornerRadius(10)
                            .shadow(color: .gray, radius: 4, x: 0, y: 2)
                        
                        CountdownTimerView(endTime: artifact.bidEndTime)
                            .padding([.bottom, .trailing], 10)
                    }
                } else {
                    ProgressView()
                        .frame(width: UIScreen.main.bounds.width / 2 - 30, height: 200)
                        .padding()
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
            self.currentImageIndex = (self.currentImageIndex + 1) % artifact.imageURLs.count
            self.loadImage(from: artifact.imageURLs[currentImageIndex])
        }
        .onAppear {
            self.loadImage(from: artifact.imageURLs[currentImageIndex])
        }
    }

    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = Image(uiImage: uiImage)
                }
            } else {
                // Handle error or use a default image
            }
        }.resume()
    }
}

//struct ArtifactDraftView_Previews: PreviewProvider {
//    static var previews: some View {
//        let viewModel = ArtifactsViewModel()
//        if let artifact = viewModel.artifacts?.first {
//            ArtifactDraftView(viewModel: viewModel, artifact: artifact)
//                .padding(.horizontal)
//                .previewLayout(.sizeThatFits)
//        } else {
//            Text("No artifacts available")
//        }
//    }
//}
