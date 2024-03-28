import SwiftUI
import FirebaseAuth

struct BidView: View {
    @State private var bidAmount: Double = 0
    @State private var isShowingAlert = false
    @ObservedObject var viewModel: ArtifactsViewModel
    var artifact: ArtifactsData
    @Environment(\.presentationMode) var presentationMode
    
    
    
    var body: some View {
        VStack {
            Text("Bid Details")
                .font(.title)
                .padding(.bottom, 10)
                .foregroundColor(.white)
            
            // Display artifact information
            VStack(alignment: .leading, spacing: 8) { // Reduce spacing between boxes
                // Artifact Name box
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color.white)
                        .shadow(color: Color.gray.opacity(0.5), radius: 3, x: 0, y: 2)
                        .frame(maxHeight: 30)
                    
                    VStack {
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
                        .padding(.bottom, 5) // Reduce bottom padding
                       
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 5) // Reduce bottom padding
                
                // Starting Price box
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color.white)
                        .shadow(color: Color.gray.opacity(0.5), radius: 3, x: 0, y: 2)
                        .frame(maxHeight: 30)
                    
                    VStack {
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
                        .padding(.bottom, 5) // Reduce bottom padding
                        
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 5) // Reduce bottom padding
                
                // Current Price box
                if let currentBid = artifact.currentBid, !currentBid.isZero {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color.white)
                            .shadow(color: Color.gray.opacity(0.5), radius: 3, x: 0, y: 2)
                            .frame(maxHeight: 30)
                        
                        VStack {
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
                            .padding(.bottom, 5) // Reduce bottom padding
                           
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 5) // Reduce bottom padding
                }
                
                // Current Bidder box (conditional)
                if let currentBid = artifact.currentBid, currentBid != 0, let currentBidder = artifact.currentBidder {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color.white)
                            .shadow(color: Color.gray.opacity(0.5), radius: 3, x: 0, y: 2)
                            .frame(maxHeight: 30)
                        
                        VStack {
                            HStack {
                                Text("Current Bidder:")
                                    .foregroundColor(.black)
                                    .font(.headline)
                                    .padding(.leading, 20)
                                Spacer()
                                Text(verbatim: "\(currentBidder)")
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 10)
                            }
                            .padding(.bottom, 5) // Reduce bottom padding
                            
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 5) // Reduce bottom padding
                }
                
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
                HStack {
                    // Cancel clickable text
                    Text("Cancel")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                        .onTapGesture {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    
                    Spacer() // Add spacer to push the bid button to the trailing side
                    
                    Button(action: {
                        if let currentUser = Auth.auth().currentUser {
                            let bidderUserID = currentUser.uid
                            viewModel.updateArtifactWithBidderInfo(artifactID: artifact.id.uuidString, bidderUserID: bidderUserID, bidAmount: bidAmount)
                        } else {
                            print("No user signed in.")
                        }
                    }) {
                        Text("Bid")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                            .onTapGesture {
                                self.presentationMode.wrappedValue.dismiss()
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(.clear), lineWidth: 2)
                            )
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    
                }
                
            }
        }
    }

