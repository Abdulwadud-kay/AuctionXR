//
//  Extensions.swift
//  AuctionX
//
//  Created by Abdulwadud Abdulkadir on 1/27/24.
//


import Foundation
import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}



extension TimeInterval {
    func toCountdownString() -> String {
        let totalSeconds = Int(self)
        let years = totalSeconds / (3600 * 24 * 365)
        let months = (totalSeconds % (3600 * 24 * 365)) / (3600 * 24 * 30)
        let weeks = (totalSeconds % (3600 * 24 * 30)) / (3600 * 24 * 7)
        let days = (totalSeconds % (3600 * 24 * 7)) / (3600 * 24)
        let hours = (totalSeconds % (3600 * 24)) / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60

        return "\(years > 0 ? "\(years)yr " : "")\(months > 0 ? "\(months)mths " : "")\(weeks > 0 ? "\(weeks)wks " : "")\(days > 0 ? "\(days)days " : "")\(hours > 0 ? "\(hours)hrs " : "")\(minutes > 0 ? "\(minutes)min " : "")\(seconds > 0 ? "\(seconds)secs" : "")"
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}


