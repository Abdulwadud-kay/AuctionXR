import SwiftUI


struct ArtifactsListView: View {
    @ObservedObject var viewModel = ArtifactsViewModel()
    var artifacts: [ArtifactsData]

        var body: some View {
            NavigationView {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(artifacts, id: \.id) { artifact in
                            NavigationLink(destination: ArtifactDetailView(viewModel: viewModel,artifact: artifact)) {
                                ArtifactSummaryView(viewModel: viewModel,artifact: artifact)
                            }

                            }
                        }
                    }
                    .padding()
                }
                .navigationBarTitle("Artifacts", displayMode: .inline)
            }
        }
    

    // Preview provider
//struct ArtifactsListView_Previews: PreviewProvider {
//    static var previews: some View {
//        let oneDayIntoFuture = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
//        let sampleArtifact = ArtifactsView(title: "Sample Artifact", description: "This is a detailed description of the artifact.", startingPrice: 100, currentBid: 150, isSold: false, likes: 10, dislikes: 5, currentBidder: "John Doe", timeRemaining: 3600, comments: 3, imageName: "sampleImage", rating: 4.5, isBidded: false, bidEndTime: oneDayIntoFuture, imageNames: ["ArtifactImage", "ArtifactImage"], videoNames: ["vid"])
//
//        ArtifactsListView(viewModel: ArtifactsViewModel(), artifacts: [sampleArtifact])
//    }
//}
