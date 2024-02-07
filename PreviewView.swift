//
//  PreviewView.swift
//  AuctionX
//
//  Created by Abdulwadud Abdulkadir on 1/23/24.
//

import SwiftUI

struct PreviewView: View {
    let backgroundColor = Color(hex: "f4e9dc")

    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)
            Text("AUCTIONX")
                .font(.system(size: 50, weight: .bold, design: .rounded)) // Larger font size
                .foregroundColor(Color.white) // White text color
                .frame(maxWidth: .infinity, maxHeight: .infinity) // Full screen
                .background(Color("dbb88e").cornerRadius(15)) // Rounded edges with custom color
        }
    }
}

struct PreviewView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewView()
    }
}

