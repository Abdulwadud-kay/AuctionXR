import SwiftUI

struct SoldItemsView: View {
    @ObservedObject var viewModel = ArtifactsViewModel()
    @EnvironmentObject var userAuthManager: UserManager

    var body: some View {
        VStack {
            Picker(selection: $viewModel.selectedSegment, label: Text("Select")) {
                Text("Bids").tag(0)
                Text("My Artifacts").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            // Content for each segment
            if viewModel.selectedSegment == 0 {
                BidsListView(viewModel: viewModel)
            } else {
                AuctionWinView()
            }

            Spacer()
        }
        .onAppear {
            viewModel.fetchArtifacts(userID: userAuthManager.userId) { result in
                // Handle completion here if needed
            }
        }
    }
}

struct BidsListView: View {
    @ObservedObject var viewModel: ArtifactsViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                if let artifacts = viewModel.artifacts, !artifacts.isEmpty {
                    ForEach(artifacts.filter { $0.isBidded }, id: \.id) { artifact in
                        CurrentArtifactView(viewModel: viewModel, artifact: artifact)
                    }
                } else {
                    PlaceholderView(text: "No Bids")
                }
            }
        }
    }
}

struct AuctionWinView: View {
    let wonItems = [
        WonItem(name: "Vintage Camera", amountPaid: "$250", deliveryDate: "April 30, 2023", authenticityGuarantee: "Certified Authentic with 2 years warranty", deliveryLocation: "123 Vintage Lane, Oldtown"),
        WonItem(name: "Antique Watch", amountPaid: "$400", deliveryDate: "May 5, 2023", authenticityGuarantee: "Verified by Expert Watchmakers with lifetime authenticity guarantee", deliveryLocation: "456 Collector's St., Timetown"),
        WonItem(name: "Rare Book Collection", amountPaid: "$150", deliveryDate: "April 28, 2023", authenticityGuarantee: "Includes certificate of authenticity from renowned book appraiser", deliveryLocation: "789 Bibliophile Blvd., Readville")
    ]

    var body: some View {
        List(wonItems) { item in
            DisclosureGroup {
                VStack(alignment: .leading) {
                    Text("Amount Paid: \(item.amountPaid)")
                        .padding(.bottom, 2)
                    Text("Delivery Date: \(item.deliveryDate)")
                        .padding(.bottom, 2)
                    Text("Authenticity: \(item.authenticityGuarantee)")
                        .padding(.bottom, 2)
                    Text("Delivery Location: \(item.deliveryLocation)")
                }
                .padding()
            } label: {
                Text("Yay! You have won the \(item.name)")
            }
            .accentColor(.black)
        }
    }
}

struct SoldItemsView_Previews: PreviewProvider {
    static var previews: some View {
        SoldItemsView()
            .environmentObject(UserManager())
    }
}

struct PlaceholderView: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.system(.body))
            .italic() // Apply the italic modifier directly to the Text view
            .foregroundColor(.gray)
            .padding()
    }
}

struct WonItem: Identifiable {
    let id = UUID()
    let name: String
    let amountPaid: String
    let deliveryDate: String
    let authenticityGuarantee: String
    let deliveryLocation: String
}
