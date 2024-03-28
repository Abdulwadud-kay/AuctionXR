import SwiftUI

struct ArtifactViewController: View {
    @ObservedObject var viewModel = ArtifactsViewModel()
    @State private var isShowingCreateArtifactView = false
    @State private var selectedTab: ArtifactTab = .drafts
    @EnvironmentObject var userAuthManager: UserManager
    @State private var artifacts: [ArtifactsData] = []
    @State private var isLoading = false
    
    
    let infoBoxColor = Color(.white)
    let buttonColor = Color(hex: "#5729CE")
    let detailBoxColor = Color(hex: "f4e9dc")
    
   
    enum ArtifactTab {
        case drafts, posts
    }
    
    var body: some View {
            NavigationView {
                VStack {
                    Picker("Select Tab", selection: Binding<ArtifactTab>(
                        get: { selectedTab },
                        set: { newValue in
                            selectedTab = newValue
                            reloadArtifacts()
                        }
                    )) {
                        Text("Drafts").tag(ArtifactTab.drafts)
                        Text("Posts").tag(ArtifactTab.posts)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()



                    ScrollView {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .padding()
                        } else {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                                ForEach(artifactsForSelectedTab, id: \.id) { artifact in
                                    if selectedTab == .posts {
                                        NavigationLink(destination: ArtifactDetailView(viewModel: viewModel, artifact: artifact)) {
                                            ArtifactSummaryView(viewModel: viewModel, artifact: artifact)
                                                .padding()
                                                .background(.white)
                                                .cornerRadius(10)
                                        }
                                    } else {
                                        NavigationLink(destination: DraftDetailsView(viewModel: viewModel, artifact: artifact)) {
                                                                                    ArtifactDraftView(viewModel: viewModel, artifact: artifact)
                                                                                        .background(.white)
                                                                                        .cornerRadius(10)
                                        }
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                    .background(infoBoxColor)
                }
                .navigationBarTitle("My Artifacts", displayMode: .inline)
                .navigationBarItems(trailing: navigationBarTrailingItem)
                .sheet(isPresented: $isShowingCreateArtifactView) {
                    CreateArtifactView(isShowingCreateArtifactView: $isShowingCreateArtifactView, artifactsViewModel: ArtifactsViewModel(), userId: userAuthManager.userId)
                }
                .onAppear(perform: loadArtifacts)
            }
        }

        private var navigationBarTrailingItem: some View {
            Button(action: {
                isShowingCreateArtifactView = true
            }) {
                HStack {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                    Text("New")
                        .foregroundColor(.white)
                }
                .padding(.all, 7)
                .background(buttonColor)
                .cornerRadius(10)
            }
        }

    private var artifactsForSelectedTab: [ArtifactsData] {
        switch selectedTab {
        case .drafts:
            return artifacts
        case .posts:
            return viewModel.artifacts ?? []
        }
    }

        private func loadArtifacts() {
            isLoading = true
            let userID = userAuthManager.userId

            if selectedTab == .posts {
                viewModel.fetchArtifacts(userID: userID) { success in
                    isLoading = !success
                }
            } else {
                viewModel.fetchDrafts(userID: userID) { success in
                    isLoading = !success
                    artifacts = viewModel.drafts ?? []
                }
            }
        }

        private func reloadArtifacts() {
            // Reload artifacts when tab selection changes
            loadArtifacts()
        }
    }
struct ArtifactViewController_Previews: PreviewProvider {
    static var previews: some View {
        ArtifactViewController()
            .environmentObject(UserManager()) // Assuming UserManager conforms to ObservableObject
    }
}
