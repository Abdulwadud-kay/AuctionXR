//
//  ProfileData.swift
//  AuctionX
//
//  Created by Abdulwadud Abdulkadir on 1/21/24.
//

import Foundation

struct Profile: Hashable {
    let id: UUID
    let username: String
    let email: String
    // Add other relevant fields
}



enum AppState {
    case initial
    case loggedIn
    case loggedOut
}
