//
//  ArtifactDetailView.swift
//  GoTwice
//
//  Created by Abdulwadud Abdulkadir on 1/8/24.
//

import Foundation
import SwiftUI

struct ArtifactDetailView: View {
    var artifact: ArtifactsView

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                // Artifact Image
                Image(artifact.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)

                // Artifact Title
                Text(artifact.title)
                    .font(.title)
                    .fontWeight(.bold)

                // Artifact Description
                Text(artifact.description)

                // Additional Details
                Text("Starting Price: $\(artifact.startingPrice, specifier: "%.2f")")
                Text("Current Bid: $\(artifact.currentBid, specifier: "%.2f")")
                Text("Time Remaining: \(artifact.timeRemaining.formattedTime)")

                // Bid Button
                Button("Place Bid") {
                    // Handle Bid Action
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)

                // Bid History or Other Details
                // ...
            }
            .padding()
        }
        .navigationBarTitle("Artifact Details", displayMode: .inline)
    }
}


