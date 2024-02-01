import SwiftUI

struct HomeViewController: View {
    @State private var searchText = ""
    @State private var isShowingProfileView = false
    @State private var selectedTabIndex = 0
    let headerFooterColor = Color(hex: "dbb88e")
    let centerColor = Color.white
    let tabTitles = ["All", "Art", "Science", "Collections", "Special"]
    @EnvironmentObject var userAuthManager: UserAuthenticationManager

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ZStack {
                    headerFooterColor
                        .frame(height: 130)  // Reduced height
                        .edgesIgnoringSafeArea(.top)

                    VStack(spacing: 45) {  // Increased spacing
                        HStack(spacing:0) {
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
                        .padding(.top, 100)  // Adjust padding to lower the elements

                        Picker("Categories", selection: $selectedTabIndex) {
                            ForEach(0..<tabTitles.count, id: \.self) { index in
                                Text(self.tabTitles[index]).tag(index)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)  // Add horizontal padding
                    }
                }

                TabView(selection: $selectedTabIndex) {
                    ForEach(0..<tabTitles.count, id: \.self) { index in
                        Text("Content for \(tabTitles[index])")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(centerColor)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: 300)
                
                Spacer()
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct HomeViewController_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewController().environmentObject(UserAuthenticationManager())
    }
}




