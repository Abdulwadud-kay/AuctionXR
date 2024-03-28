import SwiftUI
import FirebaseFirestore
import FirebaseAuth


struct AccountDetailsView: View {
    @EnvironmentObject var userAuthManager: UserManager
    @Environment(\.presentationMode) var presentationMode
    @State private var cardNumber = ""
    @State private var expiryDate = ""
    @State private var cvv = ""
    @State private var fullName = ""
    @State private var zipCode = ""
    @State private var state = "Select State"
    @State private var city = ""
    @State private var streetAddress = ""
    @State private var email = ""
    @State private var phoneNumber = ""
    @State private var isSaveEnabled = false
    
    let states = ["Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming"]
    
    var body: some View {
     
          VStack {
                Text("Account Details")
                            .font(.title)
                            .padding()
                
            ScrollView {

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
                
                TextField("Zip Code", text: $zipCode)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Picker("State", selection: $state) {
                    ForEach(states, id: \.self) { state in
                        Text(state)
                    }
                }
                .padding()
                .pickerStyle(MenuPickerStyle())
                .textFieldStyle(RoundedBorderTextFieldStyle())
                
                
                TextField("State", text: $state)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("City", text: $city)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Street Address", text: $streetAddress)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Email", text: $email)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Phone Number", text: $phoneNumber)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                HStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Cancel")
                            .foregroundColor(Color(.blue))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.trailing, 10)
                    
                    Button(action: {
                        // Perform save action
                        saveAccountDetails()
                    }) {
                        Text("Save")
                            .padding(10)
                            .padding(.horizontal,10)
                            .foregroundColor(.white)
                            .background(isSaveEnabled ? Color(.blue) : Color.gray)
                            .cornerRadius(13)
                    }
                    .frame(maxWidth: .infinity)
                    .disabled(!isSaveEnabled)
                }
                .padding(.top, 10)
            }
            .padding()
            .navigationBarTitle("Account Details", displayMode: .inline)
            .onChange(of: [cardNumber, expiryDate, cvv, fullName, zipCode, state, city, streetAddress, email, phoneNumber]) { _ in
                // Check if all fields are filled to enable Save button
                isSaveEnabled = !cardNumber.isEmpty && !expiryDate.isEmpty && !cvv.isEmpty && !fullName.isEmpty && !zipCode.isEmpty && !state.isEmpty && !city.isEmpty && !streetAddress.isEmpty && !email.isEmpty && !phoneNumber.isEmpty
            }
        }
    }

func saveAccountDetails() {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        let db = Firestore.firestore()
        let userDetails = [
            "cardNumber": cardNumber,
            "expiryDate": expiryDate,
            "cvv": cvv,
            "fullName": fullName,
            "zipCode": zipCode,
            "state": state,
            "city": city,
            "streetAddress": streetAddress,
            "email": email,
            "phoneNumber": phoneNumber
        ]
        
        db.collection("users").document(currentUser.uid).setData(userDetails) { error in
            if let error = error {
                print("Error saving account details: \(error.localizedDescription)")
            } else {
                // Account details saved successfully
                self.userAuthManager.setAccountSetup(true)
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}


struct AccountDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        AccountDetailsView()
    }
}
