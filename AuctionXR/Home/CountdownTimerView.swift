//
//  CountdownTimerView.swift
//  AuctionXR
//
//  Created by Abdulwadud Abdulkadir on 2/17/24.
//

//
//  CountdownTimerView.swift
//  UIDemo
//
//  Created by Abdulwadud Abdulkadir on 2/15/24.
//

import Foundation
import SwiftUI

struct CountdownTimerView: View {
    let endTime: Date
    @State private var timeRemaining: String = ""

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        Text(timeRemaining)
            .font(.caption)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(8)
            .background(Color.black.opacity(0.5))
            .cornerRadius(5)
            .onReceive(timer) { _ in
                updateTimeRemaining()
            }
            .onAppear(perform: updateTimeRemaining)
    }

    private func updateTimeRemaining() {
        let remaining = endTime.timeIntervalSinceNow
        if remaining > 0 {
            let days = Int(remaining) / 86400
            let hours = Int(remaining) / 3600 % 24
            let minutes = Int(remaining) / 60 % 60
            let seconds = Int(remaining) % 60
            timeRemaining = String(format: "%02dd %02dh %02dm %02ds", days, hours, minutes, seconds)
        } else {
            timeRemaining = "Time's up!"
        }
    }
}


