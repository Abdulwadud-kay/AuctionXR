//
//  PrimaryButtonStyle.swift
//  AuctionXR
//
//  Created by Abdulwadud Abdulkadir on 2/15/24.
//
import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 10) // Reduce vertical padding to decrease height
            .padding(.horizontal, 24) // Increase horizontal padding to effectively reduce width
            .frame(maxWidth: .infinity) // Continue to allow the button to expand to the width of its container
            .background(configuration.isPressed ? Color.white.opacity(0.8) : Color.white)
            .foregroundColor(.black)
            .font(.system(size: 18, weight: .bold, design: .default))
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
            .shadow(radius: 10)
            .scaleEffect(x: 0.75, y: 0.9) // Reduce width to 75% and height to 90%
    }
}
