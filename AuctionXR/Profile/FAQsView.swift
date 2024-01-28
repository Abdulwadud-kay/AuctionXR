//
//  FAQsView.swift
//  GoTwice
//
//  Created by Abdulwadud Abdulkadir on 1/11/24.
//

import Foundation
import SwiftUI

struct FAQsView: View {
    var body: some View {
        VStack {
            Text("FAQs")
                .font(.title)
            // You can add more UI components here as needed
            Text("Frequently Asked Questions content goes here.")
                .padding()
            // Add other FAQs components
        }
        .navigationBarTitle("FAQs", displayMode: .inline)
    }
}

struct FAQsView_Previews: PreviewProvider {
    static var previews: some View {
        FAQsView()
    }
}

