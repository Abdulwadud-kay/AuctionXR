import SwiftUI
import FirebaseAuth

struct BidView: View {
    @State private var bidAmount: Double = 0
    @State private var isShowingAlert = false
    @State private var showAlert = false
    @ObservedObject var viewModel: ArtifactsViewModel
    var artifact: ArtifactsData // Assuming Artifact is your data model
    var currentBidder: String
    var artifactID: String
    
    var body: some View {
        VStack {
            Text("Bid Details")
                .font(.title)
                .padding(.bottom, 10)
                .foregroundColor(Color(hex: "dbb88e")) // Set the color to dbb88e
            
            HStack { // Use HStack for labels and values
                VStack(alignment: .leading, spacing: 10) { // Set spacing between VStacks
                    Text("Artifact Name:")
                        .foregroundColor(.black)
                        .font(.headline) // Increase font size
                        .padding(.bottom, 5) // Add bottom padding
                        .frame(width: 140, alignment: .leading) // Set fixed width for label
                        .padding(.leading, 20) // Add padding to the leading edge to move it to the right
                        .background(
                            RoundedRectangle(cornerRadius: 10) // Add rounded box around text
                                .foregroundColor(Color.white) // Set background color to white
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(hex: "dbb88e"), lineWidth: 1) // Add border with dbb88e color
                                )
                        )
                    Text("Starting Price:")
                        .foregroundColor(.black)
                        .font(.headline) // Increase font size
                        .padding(.bottom, 5) // Add bottom padding
                        .frame(width: 140, alignment: .leading) // Set fixed width for label
                        .padding(.leading, 20) // Add padding to the leading edge to move it to the right
                        .background(
                            RoundedRectangle(cornerRadius: 10) // Add rounded box around text
                                .foregroundColor(Color.white) // Set background color to white
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(hex: "dbb88e"), lineWidth: 1) // Add border with dbb88e color
                                )
                        )
                    Text("Current Price:")
                        .foregroundColor(.black)
                        .font(.headline) // Increase font size
                        .padding(.bottom, 5) // Add bottom padding
                        .frame(width: 140, alignment: .leading) // Set fixed width for label
                        .padding(.leading, 20) // Add padding to the leading edge to move it to the right
                        .background(
                            RoundedRectangle(cornerRadius: 10) // Add rounded box around text
                                .foregroundColor(Color.white) // Set background color to white
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(hex: "dbb88e"), lineWidth: 1) // Add border with dbb88e color
                                )
                        )
                }
            

                
                VStack(alignment: .leading, spacing: 10) { // Set spacing between VStacks
                    Text("\(artifact.title)")
                        .foregroundColor(.black)
                        .padding(.bottom, 5) // Add bottom padding
                    Text("$\(String(format: "%.2f", artifact.startingPrice))")
                        .foregroundColor(.black)
                        .padding(.bottom, 5) // Add bottom padding
//                    Text("$\(String(format: "%.2f", artifact.currentBid))")
//                        .foregroundColor(.black)
//                        .padding(.bottom, 5) // Add bottom padding
                }
            }
            .padding(.horizontal, 20) // Add horizontal padding
            
//            Stepper("Bid Amount: $\(String(format: "%.2f", bidAmount))", value: $bidAmount, in: artifact.currentBid...100000)
//                .padding(.vertical, 10)
//            
            Button(action: {
                // Place bid logic here
                showAlert = true
                viewModel.updateFirebaseDatabaseWithBid(artifactID: artifactID, bidAmount: bidAmount, bidderUsername: currentBidder)
            }) {
                Text("Bid")
                    .foregroundColor(Color(hex: "dbb88e")) // Set the color to dbb88e
                    .padding(.vertical, 12) // Increase vertical padding
                    .frame(maxWidth: .infinity) // Make the button wider
                    .background(Color.white) // Set the background to white
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(hex: "dbb88e"), lineWidth: 2) // Add border with dbb88e color
                    )
            }
            .padding(.horizontal, 20) // Add horizontal padding
            .padding(.bottom, 20) // Add bottom padding
            
            Spacer()
        }
        .padding()
        .background(Color(hex: "dbb88e").opacity(0.2)) // Set the background to a lighter shade of dbb88e
        .cornerRadius(20)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Confirmation"), message: Text("Are you sure you want to place a bid of $\(String(format: "%.2f", bidAmount)) for \(artifact.title)?"), primaryButton: .default(Text("Confirm")) {
                // Add code to confirm bid
                isShowingAlert = false
            }, secondaryButton: .cancel())
        }
    }
}

struct BidView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ArtifactsViewModel() // Initialize your view model here
        BidView(viewModel: viewModel, artifact: ArtifactsData(
            id: UUID(),
            title: "Test Artifact",
            description: "Description",
            startingPrice: 100,
            currentBid: 150,
            isSold: false,
            likes: [], // Provide empty arrays for likes and dislikes
            dislikes: [],
            currentBidder: "Current Bidder",
            rating: 0.0,
            isBidded: false,
            bidEndDate: Date(),
            imageURLs: [],
            videoURL: [],
            category: "Category",
            timestamp: Date() // Provide a timestamp or mark it as optional
        ), currentBidder: "YourUsername", artifactID: "YourArtifactID")
    }
}

