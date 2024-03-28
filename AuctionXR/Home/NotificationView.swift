import SwiftUI

struct NotificationView: View {
    let notifications = [
        NotificationModel(profileImage: "person.crop.circle", message: "John Doe liked your post.", time: "1h"),
        NotificationModel(profileImage: "person.crop.circle", message: "Jane Smith commented on your photo.", time: "1d"),
        NotificationModel(profileImage: "person.crop.circle", message: "Mike Johnson shared your post.", time: "1s"),
        NotificationModel(profileImage: "person.crop.circle", message: "Emily Davis started following you.", time: "1yr"),
        NotificationModel(profileImage: "person.crop.circle", message: "Chris Brown mentioned you in a comment.", time: "1m"),
        NotificationModel(profileImage: "person.crop.circle", message: "Alex Wilson sent you a message.", time: "1h"),
        NotificationModel(profileImage: "person.crop.circle", message: "Samantha Miller tagged you in a post.", time: "1d"),
        NotificationModel(profileImage: "person.crop.circle", message: "George King liked your comment.", time: "1s"),
        NotificationModel(profileImage: "person.crop.circle", message: "Lucy Graham shared your story.", time: "1yr"),
        NotificationModel(profileImage: "person.crop.circle", message: "Oliver Scott invited you to an event.", time: "1m")
    ]
    
    var body: some View {
        List(notifications) { notification in
            HStack {
                Image(systemName: notification.profileImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                
                Text(notification.message)
                
                Spacer()
                
                Text(notification.time)
                    .foregroundColor(.gray)
                
                Button(action: {
                    // Action for ellipsis button
                }) {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.gray)
                }
            }
            .padding(.vertical)
        
    

           .navigationBarTitle("Notifications", displayMode: .inline)
                .padding(.bottom, 20)
            }
    }
}

struct NotificationModel: Identifiable {
    let id = UUID()
    let profileImage: String
    let message: String
    let time: String
}


struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
