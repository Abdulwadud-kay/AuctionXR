



import SwiftUI
import FirebaseFirestore

struct ArtifactViewController: View {
    @ObservedObject var viewModel = ArtifactsViewModel()
    @State private var isShowingCreateArtifactView = false
    @State private var artifacts: [ArtifactsData] = [] // Array to store real artifacts
    @State private var selectedTab: ArtifactTab = .notBidded
    @EnvironmentObject var userAuthManager: UserAuthenticationManager
    var actualUserID: String {
            userAuthManager.userData.userId
        }
    // Enum to manage the tabs for artifact categories
    enum ArtifactTab {
        case bidded, notBidded
    }

    // Custom colors for UI elements
    let infoBoxColor = Color.gray.opacity(0.2)
    let buttonColor = Color(hex:"dbb88e")
    let detailBoxColor = Color(hex:"f4e9dc")

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
                ScrollView {
                    VStack(alignment: .leading) {
                        // Filter and display artifacts based on selected tab
                        // Backend Developer: Fetch and filter artifact data from Firestore based on isBidded property
                        ForEach(artifacts.filter { $0.isBidded == (selectedTab == .bidded) }, id: \.id) { artifact in
                            ArtifactSummaryView(viewModel: viewModel,artifact: artifact)
                                .padding()
                                .background(detailBoxColor)
                                .cornerRadius(10)
                        }
                    }
                }
                .background(infoBoxColor)
            }
            .navigationBarTitle("My Artifacts", displayMode: .inline)
            .navigationBarItems(trailing: navigationBarTrailingItem)
            .sheet(isPresented: $isShowingCreateArtifactView) {
                // Replace "currentUser" with the actual user ID from Firebase
                CreateArtifactView(isShowingCreateArtifactView: $isShowingCreateArtifactView, userId: actualUserID)
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
        // Backend Developer: Implement function to fetch artifact data from Firestore
        // Update the 'artifacts' array with the fetched data
    }
}

//struct ArtifactViewController_Previews: PreviewProvider {
//    static var previews: some View {
//        ArtifactViewController()
//    }
//}
