//
//  HistoryView.swift
//  GoTwice
//
//  Created by Abdulwadud Abdulkadir on 1/11/24.
//

import Foundation
import SwiftUI


struct HistoryView: View {
    var body: some View {
        VStack {
            Text("History")
                .font(.title)
            // You can add more UI components to display the history
            Text("History content goes here.")
                .padding()
            // Add other components related to the history view
        }
        .navigationBarTitle("History", displayMode: .inline)
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}

