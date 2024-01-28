//
//  SettingsView.swift
//  GoTwice
//
//  Created by Abdulwadud Abdulkadir on 1/11/24.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {
            Text("Settings")
                .font(.title)
            // Add your settings UI components here
            Text("Settings options will be displayed here.")
                .padding()
            // Further settings components can be added as needed
        }
        .navigationBarTitle("Settings", displayMode: .inline)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

