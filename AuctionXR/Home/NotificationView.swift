import SwiftUI

struct NotificationView: View {
    // This variable would eventually be connected to your notification logic
    @State private var notifications: [String] = [
        "A five-star artifact is on the market",
        "John Pierre has just bidded on Ancient vase",
        "You have a new message from Alice",
        "Your auction for Rare Coin ends in 1 hour",
        "Congratulations! Your artifact has been sold"
    ]
    
    var body: some View {
        
        NavigationView {
            ScrollView{
                
                VStack {
                    if notifications.isEmpty {
                        Text("No Notifications")
                            .foregroundColor(.gray)
                            .italic()
                    } else {
                        // This would be your list of notifications
                        ForEach(notifications, id: \.self) { notification in
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .frame(height: 50) // Adjust the height here
                                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                                .overlay(
                                    Text(notification)
                                        .foregroundColor(.black)
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                )
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                                
                                
                            
                        }
                    }
                }
                .navigationBarTitle("Notifications", displayMode: .inline)
                .padding(.bottom, 300)
            }
        }
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
