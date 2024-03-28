import SwiftUI

struct HomeViewController: View {
    @State private var isShowingProfileView = false
    @State private var searchText = ""
    @EnvironmentObject var userAuthManager: UserManager
    @ObservedObject var artifactsViewModel = ArtifactsViewModel()
    @State private var isLoading = true
    @State private var selectedCategory: String = "All"
    @State private var showNoArtifactsText = false
    
    let tintColor = Color(hex:"#5729CE")
    
    var filteredArtifacts: [ArtifactsData] {
        var artifacts = artifactsViewModel.artifacts ?? []
        
        // Filter by search text
        if !searchText.isEmpty {
            artifacts = artifacts.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
        
        // Filter by category
        if selectedCategory != "All" {
            artifacts = artifacts.filter { $0.category == selectedCategory }
        }
        
        return artifacts
    }
    
    var body: some View {
        NavigationView{
            VStack(spacing: 0) {
                
                VStack(spacing: 10) {
                    HStack {
                        // Profile Button
                        Button(action: { isShowingProfileView = true }) {
                            ZStack {
                                Circle()
                                    .fill(Color.clear)
                                    .frame(width: 30, height: 30)
                                if let image = userAuthManager.userImage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30, height: 30)
                                        .clipShape(Circle())
                                } else {
                                    Image(systemName: "person.crop.circle")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30, height: 30)
                                        .clipShape(Circle())
                                }
                                
                            }
                            .foregroundColor(Color(hex:"#5729CE"))
                        }
                        .sheet(isPresented: $isShowingProfileView) {
                            ProfileView().environmentObject(userAuthManager)
                        }
                        .padding(.leading, 10)
                        
                        Spacer()
                        
                        // Search Bar
                        RoundedRectangle(cornerRadius: 200)
                            .fill(Color.clear)
                            .frame(maxWidth: 200, maxHeight: 30)
                            .overlay(
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor((Color(.black)))
                                        .padding(.leading, 10)
                                    TextField("Search", text: $searchText)
                                        .foregroundColor(.black)
                                        .padding(.leading, 15)
                                        .padding(.trailing, 15)
                                    Spacer()
                                }
                            )
                            .padding(.trailing, 10)
                            .padding(.vertical, 16)
                        
                        Spacer()
                        
                        NavigationLink(destination: HistoryView()) {
                            Label("", systemImage: "clock")
                                .font(.system(size: 24))
                                .frame(width: 44, height: 44)
                                .foregroundColor(Color(hex:"#5729CE"))
                        }
                    }
                    .padding(.horizontal, 10)
                    .background(Color(.white))
                    .shadow(radius: 1)
                }
                
                ScrollView {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: tintColor))
                            .padding(.top, 300)
                            .padding(.bottom, 400)
                            .onAppear {
                                // Start a timer to check if no artifacts are available after 10 seconds
                                Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { _ in
                                    if artifactsViewModel.artifacts?.isEmpty ?? true {
                                        // Show the "No artifacts available" text if no artifacts are loaded after 10 seconds
                                        showNoArtifactsText = true
                                    }
                                }
                            }
                    } else {
                        if showNoArtifactsText {
                            Text("No artifacts available")
                                .foregroundColor(.black)
                                .font(.headline)
                                .padding()
                        } else {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                                ForEach(filteredArtifacts, id: \.id) { artifact in
                                    NavigationLink(destination: ArtifactDetailView(viewModel: artifactsViewModel, artifact: artifact)) {
                                        ArtifactSummaryView(viewModel: artifactsViewModel, artifact: artifact)
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                }
                
                .edgesIgnoringSafeArea(.all)
                // Category section
                Picker("Select Category", selection: $selectedCategory) {
                    Text("All").tag("All")
                    Text("Art").tag("Art")
                    Text("Science").tag("Science")
                    Text("Collections").tag("Collections")
                    Text("Special").tag("Special")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
            }
            .onAppear {
                // Fetch artifacts when the view appears
                fetchArtifacts()
            }
            .onReceive(userAuthManager.loggedInStateChanged) { isLoggedIn in
                if isLoggedIn {
                    // Reload artifacts when user logs in
                    fetchArtifacts()
                }
            }
        }
    }
        private func fetchArtifacts() {
            artifactsViewModel.fetchAllArtifacts { success in
                isLoading = !success // Update isLoading based on fetch success
            }
        }
    }
    


struct HomeViewController_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewController()
            .environmentObject(UserManager())
            .environmentObject(ArtifactsViewModel())
    }
}
