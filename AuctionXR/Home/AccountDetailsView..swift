import SwiftUI

struct AccountDetailsView: View {
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
            
            Button(action: {
                // Add action to save account details
            }) {
                Text("Save")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color(hex: "dbb88e")) // Use dbb88e color
                    .cornerRadius(10)
            }
             // Adjust horizontal padding
            
            .frame(maxWidth: 300) // Make the button wider
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
