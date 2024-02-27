import SwiftUI

struct HomeViewController: View {
    @State private var searchText = ""
    @State private var isShowingProfileView = false
    @State private var selectedTabIndex = 0
    let headerFooterColor = Color(hex: "dbb88e")
    let centerColor = Color.white
    let tabTitles = ["All", "Art", "Science", "Collections", "Special"]
    @EnvironmentObject var userAuthManager: UserAuthenticationManager
    @EnvironmentObject var artifactsViewModel: ArtifactsViewModel // Make sure this is provided in the environment
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ZStack {
                    headerFooterColor
                        .frame(height: 130)
                        .edgesIgnoringSafeArea(.top)
                    
                    VStack(spacing: 80) {
                        HStack(spacing: 0) {
                            // Profile Button
                            Button(action: { isShowingProfileView = true }) {
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.white)
                            }
                            .sheet(isPresented: $isShowingProfileView) {
                                ProfileView().environmentObject(userAuthManager)
                            }
                            .padding(.leading, 15)
                            
                            Spacer()
                            
                            // Search Bar
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.black)
                                    .padding(.leading, 10)
                                
                                TextField("Search", text: $searchText)
                                    .padding(.vertical, 6)
                            }
                            .background(RoundedRectangle(cornerRadius: 30).fill(Color.white))
                            .frame(height: 100)
                            
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
                        .frame(height: 0)
                        .padding(.top, 130)
                        
                        // Category Picker
                        Picker("Categories", selection: $selectedTabIndex) {
                            ForEach(0..<tabTitles.count, id: \.self) { index in
                                Text(self.tabTitles[index]).tag(index)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
                .padding(.bottom, 700)
                
                // Tab View for Artifact Categories
                //                TabView(selection: $selectedTabIndex) {
                //                    ForEach(0..<tabTitles.count, id: \.self) { index in
                //                        if filteredArtifacts.isEmpty {
                //                            Text("No artifacts available")
                //                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                //                        } else {
                //                            ArtifactsListView(viewModel: artifactsViewModel, artifacts: filteredArtifacts)
                //                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                //                        }
                //                            .background(centerColor)
                //                            .tag(index)
                //                    }
                //                }
                //                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
//                                .frame(height: 300)
                //
//                Spacer()
            }
            .background(RoundedRectangle(cornerRadius: 30).fill(Color.white))
            .frame(height: 40)
            .edgesIgnoringSafeArea(.all)
        
            }
        }
        
        // Computed property for filtered artifacts
        var filteredArtifacts: [ArtifactsData] {
            let filteredByCategory = artifactsViewModel.artifacts.filter { artifact in
                selectedTabIndex == 0 || artifact.category == tabTitles[selectedTabIndex].lowercased()
            }
            
            if searchText.isEmpty {
                return filteredByCategory
            } else {
                return filteredByCategory.filter { artifact in
                    artifact.title.lowercased().contains(searchText.lowercased())
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
