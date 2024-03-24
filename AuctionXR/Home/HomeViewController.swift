import SwiftUI

struct HomeViewController: View {
    @State private var isShowingProfileView = false
    @State private var searchText = ""
    let headerColor = Color(hex: "dbb88e")
    let centerColor = Color.white
    @EnvironmentObject var userAuthManager: UserAuthenticationManager
    @ObservedObject var artifactsViewModel = ArtifactsViewModel()
    @State private var isLoading = true // Added isLoading state

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 0) { // Use VStack to apply headerColor background to the entire header section
                    headerColor
                        .frame(height: 90)
                        .edgesIgnoringSafeArea(.top)
                    
                    // Overlay VStack containing profile icon, search bar, and cart icon
                    VStack(spacing: 10) {
                        HStack {
                            // Profile Button
                            Button(action: { isShowingProfileView = true }) {
                                ZStack {
                                    Circle()
                                        .fill(Color.clear)
                                        .frame(width: 30, height: 30)
                                    if let image = userAuthManager.userData.userImage {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFit()
                                            .clipShape(Circle())
                                    } else {
                                        Image(systemName: "person.crop.circle")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                    }
                                }
                                .foregroundColor(.white)
                            }
                            .sheet(isPresented: $isShowingProfileView) {
                                ProfileView().environmentObject(userAuthManager)
                            }
                            .padding(.leading, 15)
                            
                            Spacer()
                            
                            // Search Bar
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.white)
                                .frame(maxWidth: 200, maxHeight: 30) // Set maxWidth to allow extension on both sides
                                .overlay(
                                    HStack {
                                        Image(systemName: "magnifyingglass")
                                            .foregroundColor(.black)
                                            .padding(.leading, 10)
                                        TextField("Search", text: $searchText) // Use TextField instead of Text
                                            .foregroundColor(.black)
                                            .padding(.leading, 5) // Adjust padding as needed
                                            .padding(.trailing, 5) // Adjust padding as needed
                                        Spacer()
                                    }
                                )
                                .padding(.trailing, 10)
                                .padding(.vertical, 6)
                            
                            Spacer()
                            
                            // Cart Navigation
                            NavigationLink(destination: SoldItemsView()) {
                                VStack {
                                    Image(systemName: "cart")
                                        .foregroundColor(.white)
                                    Text("cart")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.trailing, 10)
                            .padding(.top, 6)
                            .padding(.vertical, 6)
                            
                        }
                        .padding(.horizontal) // Add horizontal padding for the whole HStack
                        .cornerRadius(15) // Optional: Add corner radius if needed
                        .background(Color(headerColor))
                        
                    }
                }
                
                // Space for displaying artifacts
                if isLoading { // Check isLoading state
                    // Show loading indicator
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: headerColor))
                        .padding(.top, 300)
                        .padding(.bottom, 400)
                } else {
                    // Display artifacts in two columns
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            ForEach(artifactsViewModel.artifacts ?? [], id: \.id) { artifact in
                                ArtifactSummaryView(viewModel: artifactsViewModel, artifact: artifact)
                            }
                        }
                        .padding()
                    }
                    .background(Color.white) // Ensure consistent background color
                     // Adjust spacing as needed
                }
            }
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                // Fetch all artifacts
                artifactsViewModel.fetchAllArtifacts { success in
                    isLoading = !success // Update isLoading based on success of fetching
                }
            }
        }
    }
}

struct HomeViewController_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewController()
            .environmentObject(UserAuthenticationManager())
            .environmentObject(ArtifactsViewModel())
    }
}
