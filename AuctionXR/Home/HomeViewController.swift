import SwiftUI

struct HomeViewController: View {
    @State private var searchText = ""
    @State private var isShowingProfileView = false
    @State private var selectedTabIndex = 0
    let headerFooterColor = Color(hex: "dbb88e")
    let centerColor = Color(hex: "f4e9dc")
    let tabTitles = ["All", "Art", "Science", "Collections", "Special"]
    @EnvironmentObject var userAuthManager: UserAuthenticationManager
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ZStack {
                    headerFooterColor
                        .frame(height: 140)
                        .edgesIgnoringSafeArea(.top)
                    
                    VStack {
                        HStack(spacing: 10) {
                            // Profile Icon as a button that sets the selected profile
                            // Profile Icon as a button for navigation
                            // Profile Icon as a button for navigation
                            Button(action: {
                                isShowingProfileView = true
                            }) {
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.white)
                            }
                            .sheet(isPresented: $isShowingProfileView) {
                                ProfileView().environmentObject(userAuthManager)
                            }
                            .padding(.leading, 10)


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
                            .frame(height: 40)

                            Spacer()

                            // Cart Icon
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
                        .frame(height: 40)
                        .padding(.top, 45)
                        
                        // Picker as the segmented control for tabs
                        Picker("Categories", selection: $selectedTabIndex) {
                            ForEach(0..<tabTitles.count, id: \.self) { index in
                                Text(self.tabTitles[index]).tag(index)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                        .background(headerFooterColor)
                    }
                }

                // TabView for swiping between tabs
                TabView(selection: $selectedTabIndex) {
                    ForEach(0..<tabTitles.count, id: \.self) { index in
                        // Replace with actual content views for each tab
                        Text("Content for \(tabTitles[index])")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(centerColor)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: 300) // Adjust this height as needed
                
                Spacer()
                // Center Content (if any)
                // ...
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}



struct HomeViewController_Previews: PreviewProvider {
    @State static var appState = AppState.loggedOut // Provide an initial appState

    static var previews: some View {
        HomeViewController(appState: $appState).environmentObject(UserData())
    }
}
