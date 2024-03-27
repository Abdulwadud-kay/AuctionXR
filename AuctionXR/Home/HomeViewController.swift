import SwiftUI

struct HomeViewController: View {
    @State private var isShowingProfileView = false
    @State private var searchText = ""
    @EnvironmentObject var userAuthManager: UserManager
    @ObservedObject var artifactsViewModel = ArtifactsViewModel()
    @State private var isLoading = true // Added isLoading state
    @State private var selectedCategory: String = "All" // Added selectedCategory state
    
    let tintColor = Color(hex:"#5729CE")
    
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
                                        .scaledToFit()
                                        .clipShape(Circle())
                                } else {
                                    Image(systemName: "person.crop.circle")
                                        .resizable()
                                        .frame(width: 30, height: 30)
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
                    } else {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            ForEach(artifactsViewModel.artifacts ?? [], id: \.id) { artifact in
                                NavigationLink(destination: ArtifactDetailView(viewModel: artifactsViewModel, artifact: artifact)) {
                                    ArtifactSummaryView(viewModel: artifactsViewModel, artifact: artifact)
                                }
                            }
                        }
                        .padding()
                        
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
                artifactsViewModel.fetchAllArtifacts { success in
                    isLoading = !success // Update isLoading based on fetch success
                }
            }
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
