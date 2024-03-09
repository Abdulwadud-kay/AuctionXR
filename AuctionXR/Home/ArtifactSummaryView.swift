//
//  ArtifactSummaryView.swift
//  GoTwice
//
//  Created by Abdulwadud Abdulkadir on 1/8/24.
//

import SwiftUI


struct ArtifactSummaryView: View {
    @ObservedObject var viewModel: ArtifactsViewModel
    var artifact: ArtifactsData
    @State private var isNavigationActive = false
    
    var body: some View {
        VStack {
            NavigationLink(destination: ArtifactDetailView(viewModel: viewModel, artifact: artifact), isActive: $isNavigationActive) {
                EmptyView()
            }
            .hidden()
            
            Button(action: {
                self.isNavigationActive = true
            }) {
                ZStack(alignment: .bottomTrailing) {
                    // Using AsyncImage to load an image from a URL
                    AsyncImage(url: artifact.imageURL) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width / 2 - 30, height: 200)
                    .cornerRadius(10)
                    .shadow(color: .gray, radius: 4, x: 0, y: 2)
                    
                    CountdownTimerView(endTime: artifact.bidEndTime)
                        .padding([.bottom, .trailing], 10)
                }
            }
            
            Text(artifact.title)
                .font(.headline)
                .fontWeight(.bold)
                .padding(.top, 2)
            
            Text("Current Bid: $\(artifact.currentBid, specifier: "%.2f")")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.bottom, 2)
            
            HStack {
                ForEach(0..<Int(artifact.rating.rounded()), id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }
            }
            .padding(.all, 10)
            .cornerRadius(10)
            .frame(width: UIScreen.main.bounds.width / 2 - 20)
        }
    }
}





struct ArtifactSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ArtifactsViewModel() // Ensure this is initialized correctly
        // Fetch data or provide sample data for preview
        viewModel.fetchArtifacts() // Assuming this works synchronously for preview

        return HStack {
            if let artifacts = viewModel.artifacts, artifacts.count > 1 {
                ArtifactSummaryView(viewModel: viewModel, artifact: artifacts[0])
                ArtifactSummaryView(viewModel: viewModel, artifact: artifacts[1])
            }

        }
        .padding(.horizontal)
        .previewLayout(.sizeThatFits)
    }
}


//struct ArtifactSummaryView_Previews: PreviewProvider {
//    static var previews: some View {
//        ArtifactSummaryView()
//    }
//}
