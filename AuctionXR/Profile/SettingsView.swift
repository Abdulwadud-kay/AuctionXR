import SwiftUI

struct SettingsView: View {
    @State private var isAccountDetailsViewPresented = false
    
    var body: some View {
        VStack {
            Text("Settings")
                .font(.title)
                .padding(.bottom, 60) // Add padding to the top of the "Settings" text
            
            // Add your settings UI components here
            Text("Settings options will be displayed here.")
                .padding(.trailing, 60) // Add trailing padding to the text
                .padding(.bottom, 20) // Add padding to the top of the text
            
            // Button to update account information
            Button(action: {
                // Set the flag to present the account details view
                self.isAccountDetailsViewPresented = true
            }) {
                Text("Update Account Info")
                    .foregroundColor(.blue)
                    .padding([.leading, .trailing]) // Add padding to the leading and trailing of the button text
                    .padding(.top) // Add padding to the top of the button
                    .padding(.bottom, 5) // Reduce bottom padding of the button
                    .background(Color.white) // Set button background color to white
                    .cornerRadius(10)
                    .shadow(radius: 2) // Add shadow to the button
            }
            .padding(.trailing, 160) // Add trailing padding to the button
            .padding(.bottom, 590)
            // Further settings components can be added as needed
        }
        .navigationBarTitle("Settings", displayMode: .inline)
        .sheet(isPresented: $isAccountDetailsViewPresented) {
            // Present the AccountDetailsView when the button is tapped
            AccountDetailsView()
        }
    }
}
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
