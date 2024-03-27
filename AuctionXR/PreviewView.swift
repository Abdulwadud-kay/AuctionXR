import SwiftUI

struct PreviewView: View {
    var body: some View {
        ZStack {
            Color(.white).edgesIgnoringSafeArea(.all) // Set background color
            
            // Logo
            Image("auctionbox") // Assuming "auctionbox" is the name of your logo asset in Assets.xcassets
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)// Adjust size as needed
                .foregroundColor(.white) // Set logo color
        }
    }
}

struct PreviewView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewView()
    }
}
