import SwiftUI

struct ArtifactDraftView: View {
    @ObservedObject var viewModel: ArtifactsViewModel
    var artifact: ArtifactsData
    @State private var isNavigationActive = false
    @State private var image: Image?

    var body: some View {
        VStack {
            Button(action: {
                isNavigationActive = true
            }) {
                if let image = image {
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width / 2 - 30, height: 200)
                        .cornerRadius(10)
                        .shadow(color: .gray, radius: 4, x: 0, y: 2)
                } else {
                    // Placeholder or loading indicator while image is being loaded
                    ProgressView()
                        .frame(width: UIScreen.main.bounds.width / 2 - 30, height: 200)
                        .padding()
                }
            }
            .buttonStyle(PlainButtonStyle()) // Hide button style

            NavigationLink(destination: DraftDetailsView(viewModel: viewModel, artifact: artifact), isActive: $isNavigationActive) {
                EmptyView()
            }

            .hidden()

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

            // Post button below the stars
            Button("Post") {
                // Implement Post Action
            }
            .buttonStyle(PrimaryButtonStyle()) // Apply your custom button style here
            .padding(.top, 5) // Add some padding on top for spacing
        }
        .onAppear {
            self.loadImage(from: artifact.imageURL)
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


struct ArtifactDraftView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ArtifactsViewModel()
        if let artifact = viewModel.artifacts?.first {
            ArtifactDraftView(viewModel: viewModel, artifact: artifact)
                .padding(.horizontal)
                .previewLayout(.sizeThatFits)
        } else {
            Text("No artifacts available")
        }
    }
}
