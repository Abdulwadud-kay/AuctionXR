// BidView.swift

import SwiftUI
import FirebaseAuth

struct BidView: View {
    @State private var bidAmount: Double = 0
    @State private var isShowingAlert = false
    @ObservedObject var viewModel: ArtifactsViewModel
    var artifact: ArtifactsData
    
    var body: some View {
        VStack {
            Text("Bid Details")
                .font(.title)
                .padding(.bottom, 10)
                .foregroundColor(.white)
            
            // Display artifact information
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Text("Artifact Name:")
                        .foregroundColor(.black)
                        .font(.headline)
                        .padding(.leading, 20)
                    Spacer() // Add spacer to push text to the left
                    Text("\(artifact.title)")
                        .foregroundColor(.black)
                        .padding(.horizontal, 10)
                        .fixedSize(horizontal: false, vertical: true) // Allow the text to wrap
                }
                .padding(.bottom, 10)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color.white)
                        .shadow(color: Color.gray.opacity(0.5), radius: 3, x: 0, y: 2) // Apply shadow
                )
                
                HStack {
                    Text("Starting Price:")
                        .foregroundColor(.black)
                        .font(.headline)
                        .padding(.leading, 20)
                    Spacer()
                    Text("$\(String(format: "%.2f", artifact.startingPrice))")
                        .foregroundColor(.black)
                        .padding(.horizontal, 10)
                }
                .padding(.bottom, 10)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color.white)
                        .shadow(color: Color.gray.opacity(0.5), radius: 3, x: 0, y: 2) // Apply shadow
                )
                
                if let currentBid = artifact.currentBid, !currentBid.isZero {
                    HStack {
                        Text("Current Price:")
                            .foregroundColor(.black)
                            .font(.headline)
                            .padding(.leading, 20)
                        Spacer()
                        Text("$\(String(format: "%.2f", currentBid))")
                            .foregroundColor(.black)
                            .padding(.horizontal, 10)
                    }
                    .padding(.bottom, 10)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color.white)
                            .shadow(color: Color.gray.opacity(0.5), radius: 3, x: 0, y: 2) // Apply shadow
                    )
                    
                    HStack {
                        Text("Current Bidder:")
                            .foregroundColor(.black)
                            .font(.headline)
                            .padding(.leading, 20)
                        Spacer()
                        Text("\(artifact.currentBidder)")
                            .foregroundColor(.black)
                            .padding(.horizontal, 10)
                    }
                    .padding(.bottom, 10)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color.white)
                            .shadow(color: Color.gray.opacity(0.5), radius: 3, x: 0, y: 2) // Apply shadow
                    )
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
                .frame(height: 60) // Adjust the height of the spacer
            
            // Bid amount stepper
            Stepper("Bid Amount: $\(String(format: "%.2f", bidAmount))", value: $bidAmount, in: (artifact.currentBid ?? artifact.startingPrice)...Double.infinity)
                .padding(.horizontal,8)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color.white)
                        .shadow(color: Color.gray.opacity(0.5), radius: 3, x: 0, y: 2) // Apply shadow
                )
                .foregroundColor(.black) // Set the foreground color to black
            
            // Bid button
            Button(action: {
                // Place bid logic here
                isShowingAlert = true
                viewModel.updateFirebaseDatabaseWithBid(artifactID: artifact.id.uuidString, bidAmount: bidAmount, bidderUsername: "YourUsername")
            }) {
                Text("Bid")
                    .foregroundColor(Color(.black))
                    .padding(.vertical, 10)
                    .padding(.horizontal, 25)
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.clear), lineWidth: 2)
                    )
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            
            Spacer()
        }
        .padding()
        .background(Color(hex:"#5729CE"))
        .cornerRadius(20)
        .alert(isPresented: $isShowingAlert) {
            Alert(title: Text("Confirmation"), message: Text("Are you sure you want to place a bid of $\(String(format: "%.2f", bidAmount)) for \(artifact.title)?"), primaryButton: .default(Text("Confirm")) {
                // Add code to confirm bid
                isShowingAlert = false
            }, secondaryButton: .cancel())
        }
    }
}
    
//    struct BidView_Previews: PreviewProvider {
//        static var previews: some View {
//            let viewModel = ArtifactsViewModel()
//            BidView(viewModel: viewModel, artifact: ArtifactsData(
//                id: UUID(),
//                title: "Test Artifact",
//                description: "Description",
//                startingPrice: 100,
//                currentBid: 150,
//                isSold: false,
//                likes: [], 
//                dislikes: [],
//                currentBidder: "Current Bidder",
//                rating: 0.0,
//                isBidded: false,
//                bidEndDate: Date(),
//                imageUrls: [],
//                videoUrl: [],
//                category: "Category",
//                timestamp: Date() // Provide a timestamp or mark it as optional
//            ))
//        }
//    }
//    
//}
