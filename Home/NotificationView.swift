import SwiftUI

struct NotificationView: View {
    // This variable would eventually be connected to your notification logic
    @State private var notifications: [String] = []

    var body: some View {
        NavigationView {
            VStack {
                if notifications.isEmpty {
                    Text("No Notifications")
                        .foregroundColor(.gray)
                        .italic()
                } else {
                    // This would be your list of notifications
                    List(notifications, id: \.self) { notification in
                        Text(notification)
                    }
                }
            }
            .navigationBarTitle("Notifications", displayMode: .inline)
        }
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
