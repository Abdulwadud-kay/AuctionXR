//
//  ProfileDetailView.swift
//  AuctionX
//
//  Created by Abdulwadud Abdulkadir on 1/19/24.
//

import Foundation
import SwiftUI

struct ProfileDetailView: View {
    @EnvironmentObject var userData: UserData

    var body: some View {
        VStack {
            Text("User Profile")
                .font(.largeTitle)
                .padding()

            // Displaying the initial in a large circle
            Circle()
                .fill(Color.gray)
                .frame(width: 100, height: 100)
                .overlay(
                    Text(userData.userInitial)
                        .font(.largeTitle)
                        .foregroundColor(.white)
                )

            // Displaying the user's email
            Text(userData.userEmail)
                .font(.title)
                .padding()

            Spacer()
        }
        .padding()
        .navigationBarTitle("Profile", displayMode: .inline)
    }
}

struct ProfileDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileDetailView().environmentObject(UserData())
    }
}
