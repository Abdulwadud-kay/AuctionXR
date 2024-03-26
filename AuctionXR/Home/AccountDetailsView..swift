import SwiftUI

struct AccountDetailsView: View {
    @EnvironmentObject var userAuthManager: UserManager
    
    @State private var cardNumber = ""
    @State private var expiryDate = ""
    @State private var cvv = ""
    @State private var fullName = ""
    
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
                    // Add action to save account details and set isAccountSetup to true
                    self.userAuthManager.isAccountSetup = true
                }) {
                    Text("Save")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color(hex: "#5729CE"))
                        .cornerRadius(10)
                }
                .frame(maxWidth: 150)
                
                Button(action: {
                    // Add action to cancel and set isAccountSetup to false
                    self.userAuthManager.isAccountSetup = false
                }) {
                    Text("Cancel")
                        .foregroundColor(Color(hex: "#5729CE")) // Use the specified color
                        .padding(.leading, 10) // Add padding to the leading edge
                }
                .frame(maxWidth: 150)
                .padding(.trailing, 10) // Add padding to the trailing edge
            }
            .padding(.top, 10) // Add spacing between the Save and Cancel buttons
        }
        .padding()
        .navigationBarTitle("Account Details", displayMode: .inline)
    }
}


struct AccountDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        AccountDetailsView()
    }
}
