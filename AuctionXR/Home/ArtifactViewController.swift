import SwiftUI

struct ArtifactViewController: View {
    @ObservedObject var viewModel = ArtifactsViewModel()
    @State private var isShowingCreateArtifactView = false
    @State private var artifacts: [ArtifactsData] = [] // Array to store real artifacts
    @State private var selectedTab: ArtifactTab = .notBidded
    @EnvironmentObject var userAuthManager: UserManager
    @State private var isLoading = false // Add loading state
    
    // Custom colors for UI elements
    let infoBoxColor = Color.gray.opacity(0.2)
    let buttonColor = Color(hex: "#5729CE")
    let detailBoxColor = Color(hex: "f4e9dc")
    
    var actualUserID: String {
        userAuthManager.userId
    }
    
    // Enum to manage the tabs for artifact categories
    enum ArtifactTab {
        case bidded, notBidded
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Segmented control for switching between bidded and not bidded artifacts
                Picker("Select Tab", selection: $selectedTab) {
                    Text("Drafts").tag(ArtifactTab.notBidded)
                    Text("Posts").tag(ArtifactTab.bidded)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // Scroll view to display artifacts based on selected tab
                // Scroll view to display artifacts based on selected tab
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(artifacts.filter { $0.isBidded == (selectedTab == .bidded) }, id: \.id) { artifact in
                            if selectedTab == .bidded {
                                ArtifactSummaryView(viewModel: viewModel, artifact: artifact)
                                    .padding()
                                    .background(detailBoxColor)
                                    .cornerRadius(10)
                            } else {
                                ArtifactDraftView(viewModel: viewModel, artifact: artifact)
                                    .padding()
                                    .background(detailBoxColor)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding()
                }
                .background(infoBoxColor)

            }
            .navigationBarTitle("My Artifacts", displayMode: .inline)
            .navigationBarItems(trailing: navigationBarTrailingItem)
            .sheet(isPresented: $isShowingCreateArtifactView) {
                // Replace "currentUser" with the actual user ID from Firebase
                CreateArtifactView(isShowingCreateArtifactView: $isShowingCreateArtifactView, artifactsViewModel: ArtifactsViewModel(), userId: actualUserID)
            }
            .onAppear(perform: loadArtifacts) // Load artifacts when view appears
        }
    }
    
    private var navigationBarTrailingItem: some View {
        // Button to show the view for creating a new artifact
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
    
    private func loadArtifacts() {
        // Set loading state to true when fetching starts
        isLoading = true
        
        // Fetch artifacts based on selected tab and user ID
        let userID = actualUserID // Assuming you have the actualUserID property defined
        
        if selectedTab == .bidded {
            viewModel.fetchArtifacts(userID: userID) { success in
                // Set isLoading based on the success of fetching
                isLoading = !success
            }
        } else {
            viewModel.fetchDrafts(userID: userID) { success in
                // Set isLoading based on the success of fetching
                isLoading = !success
            }
        }
        
        // No need to set isLoading to false here as it will be set in the completion handler
    }
}
