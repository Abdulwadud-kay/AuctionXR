//
//  HelpView.swift
//  GoTwice
//
//  Created by Abdulwadud Abdulkadir on 1/11/24.
//

import Foundation
import SwiftUI


struct HelpView: View {
    var body: some View {
        VStack {
            Text("Help & Support")
                .font(.title)
            // Here you can add more UI components related to help and support
            Text("Information about help and support features goes here.")
                .padding()
            // Further implementation for help-related components
        }
        .navigationBarTitle("Help", displayMode: .inline)
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}

