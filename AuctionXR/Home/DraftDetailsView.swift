import SwiftUI

struct DraftDetailsView: View {
    @ObservedObject var viewModel: ArtifactsViewModel
    var artifact: ArtifactsData
    @State private var showDeleteConfirmation = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                MediaCarouselView(images: artifact.imageURLs, videos: artifact.videoURL)
                    .frame(height: 300)
                    .cornerRadius(10)
                    .shadow(radius: 5)

                HStack {
                    Text(artifact.title)
                        .font(.headline)
                        .fontWeight(.bold)
                    Spacer()
                    Button(action: {
                        showDeleteConfirmation = true
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                    .padding(.trailing, 10)
                }
                .padding(.top)

                Text(artifact.description)
                    .font(.subheadline)
                    .padding(.vertical)
                    .lineLimit(nil)

                HStack(spacing: 10) {
                    Spacer()
                    Text("Bid End Time: \(formattedBidEndTime())")
                        .foregroundColor(.secondary)
                }
                .padding(.vertical)

                HStack {
                    ratingStars(rating: artifact.rating)
                    Spacer()
                    Button("Edit") {
                        // Implement Edit Action
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    Button("Post") {
                        // Implement Post Action
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
                .padding(.bottom)
            }
            .padding(.horizontal)
        }
        .navigationBarTitle(Text(artifact.title), displayMode: .inline)
        .alert(isPresented: $showDeleteConfirmation) {
            Alert(
                title: Text("Delete Artifact"),
                message: Text("Are you sure you want to delete this artifact?"),
                primaryButton: .destructive(Text("Delete")) {
                    // Implement delete functionality
                },
                secondaryButton: .cancel()
            )
        }
    }

    private func ratingStars(rating: Double) -> some View {
        HStack {
            ForEach(0..<5, id: \.self) { index in
                Image(systemName: index < Int(rating) ? "star.fill" : "star")
                    .foregroundColor(index < Int(rating) ? .yellow : .gray)
            }
        }
    }

    private func formattedBidEndTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        return dateFormatter.string(from: artifact.bidEndTime)
    }
}
