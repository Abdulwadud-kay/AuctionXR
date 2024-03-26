import SwiftUI

struct AccountDetailsView: View {
    @EnvironmentObject var userAuthManager: UserManager
    @Environment(\.presentationMode) var presentationMode
    @State private var cardNumber = ""
    @State private var expiryDate = ""
    @State private var cvv = ""
    @State private var fullName = ""
    @State private var isSaveEnabled = false
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "creditcard.fill")
                    .foregroundColor(.black)
                    .padding(.leading)
                
                TextField("Card Number", text: $cardNumber)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            HStack {
                TextField("MM-YY", text: $expiryDate)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Spacer()
                
                Text("Expiry Date")
                    .foregroundColor(.black)
                    .padding(.trailing)
            }
            
            TextField("CVV", text: $cvv)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Full Name", text: $fullName)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            HStack {
                            Button(action: {
                                self.presentationMode.wrappedValue.dismiss()
                            }) {
                                Text("Cancel")
                        .foregroundColor(Color(hex: "#5729CE"))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.trailing, 10)
                            
                            Button(action: {
                                // Perform save action
                                self.userAuthManager.setAccountSetup(true)
                                self.presentationMode.wrappedValue.dismiss()
                            }) {
                                Text("Save")
                                    .padding(10)
                                    .padding(.horizontal,10)
                                    .foregroundColor(.white)
                                    .background(isSaveEnabled ? Color(hex: "#5729CE") : Color.gray)
                                    .cornerRadius(13)
                            }
                            .frame(maxWidth: .infinity)
                            .disabled(!isSaveEnabled)
                        }
                        .padding(.top, 10)
                    }
                    .padding()
                    .navigationBarTitle("Account Details", displayMode: .inline)
                    .onChange(of: [cardNumber, expiryDate, cvv, fullName]) { _ in
                        // Check if all fields are filled to enable Save button
                        isSaveEnabled = !cardNumber.isEmpty && !expiryDate.isEmpty && !cvv.isEmpty && !fullName.isEmpty
                    }
                }
            }
struct AccountDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        AccountDetailsView()
    }
}
