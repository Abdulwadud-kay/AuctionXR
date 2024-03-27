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
                MyArtifactsListView(viewModel: viewModel)
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

struct MyArtifactsListView: View {
    @ObservedObject var viewModel: ArtifactsViewModel
    @EnvironmentObject var userAuthManager: UserManager

    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                if let artifacts = viewModel.artifacts, !artifacts.isEmpty {
                    ForEach(artifacts.filter { $0.currentBidder == userAuthManager.userId }, id: \.id) { artifact in
                        CurrentArtifactView(viewModel: viewModel, artifact: artifact)
                    }
                } else {
                    PlaceholderView(text: "No Artifacts")
                }
            }
        }
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
