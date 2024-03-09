import SwiftUI

struct HomeViewController: View {
    @State private var isShowingProfileView = false
    @State private var selectedTabIndex = 0
    let headerFooterColor = Color(hex:"dbb88e")
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
                            // Profile Button
                            Button(action: { isShowingProfileView = true }) {
                                ZStack {
                                    Circle()
                                        .fill(Color.gray)
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
                            Button(action: {
                                    // Handle search action
                                }) {
                                    HStack {
                                        Image(systemName: "magnifyingglass")
                                            .foregroundColor(.white)
                                            .padding(.trailing, 5)
                                        Text("Search")
                                            .foregroundColor(.white)
                                    }
                                }
                                .padding(.trailing, 10)
                                .padding(.top, 6)
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
                // Add your TabView here if needed
                
            }
            .background(RoundedRectangle(cornerRadius: 30).fill(Color.white))
            .frame(height: 40)
            .edgesIgnoringSafeArea(.all)
        
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
