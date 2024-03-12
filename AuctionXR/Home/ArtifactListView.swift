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
    

