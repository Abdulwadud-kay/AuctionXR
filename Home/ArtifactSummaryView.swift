//
//  ArtifactSummaryView.swift
//  GoTwice
//
//  Created by Abdulwadud Abdulkadir on 1/8/24.
//

import Foundation
import SwiftUI

struct ArtifactSummaryView: View {
    var artifact: ArtifactsView
    var body: some View {
        NavigationLink(destination: ArtifactDetailView(artifact: artifact)) {
            VStack {
                Image(artifact.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                Text(artifact.title)
                    .fontWeight(.bold)
                Text("Current Bid: $\(artifact.currentBid, specifier: "%.2f")")
                HStack {
                    ForEach(0..<5) { _ in
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                    }
                    Spacer()
                    Image(systemName: "hand.thumbsup")
                    Text("\(artifact.likes)")
                    Image(systemName: "hand.thumbsdown")
                    Text("\(artifact.dislikes)")
                    Image(systemName: "message")
                    Text("\(artifact.comments)")
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
        }
    }
}

//struct ArtifactSummaryView_Previews: PreviewProvider {
//    static var previews: some View {
//        ArtifactSummaryView()
//    }
//}
