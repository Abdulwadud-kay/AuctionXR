import Foundation
import FirebaseFirestore

struct ArtifactsData: Identifiable, Codable {
    var id: UUID
    var title: String
    var description: String
    var startingPrice: Double
    var currentBid: Double?
    var isSold: Bool
    var likes: [String]?
    var dislikes: [String]?
    var currentBidder: String?
    var rating: Double
    var isBidded: Bool
    var bidEndDate: Date?
    var imageUrls: [String]?
    var videoUrl: [String]?
    var category: String
    var timestamp: Date?
    var userID: String
       

    // Additional initializer for mapping Firestore data
    init?(id: String, data: [String: Any]) {
        guard let title = data["title"] as? String,
              let description = data["description"] as? String,
              let startingPrice = data["startingPrice"] as? Double,
              let isSold = data["isSold"] as? Bool,
              let currentBidder = data["currentBidder"] as? String,
              let rating = data["rating"] as? Double,
              let isBidded = data["isBidded"] as? Bool,
              let bidEndDateTimestamp = data["bidEndDate"] as? Timestamp,
              let imageUrls = data["imageUrls"] as? [String],
              let category = data["category"] as? String,
              let userID = data["userID"] as? String else {
            return nil
        }
        
        // Optional properties
        let currentBid = data["currentBid"] as? Double
        let likes = data["likes"] as? [String]
        let dislikes = data["dislikes"] as? [String]
        let videoUrl = data["videoUrl"] as? [String]
        let timestamp = (data["timestamp"] as? Timestamp)?.dateValue()
        let bidEndDate = bidEndDateTimestamp.dateValue()

        self.id = UUID(uuidString: id) ?? UUID()
                self.title = title
                self.description = description
                self.startingPrice = startingPrice
                self.currentBid = currentBid
                self.isSold = isSold
                self.likes = likes
                self.dislikes = dislikes
                self.currentBidder = currentBidder
                self.rating = rating
                self.isBidded = isBidded
                self.bidEndDate = bidEndDate
                self.imageUrls = imageUrls
                self.videoUrl = videoUrl
                self.category = category
                self.timestamp = timestamp
                self.userID = userID
    }
}
