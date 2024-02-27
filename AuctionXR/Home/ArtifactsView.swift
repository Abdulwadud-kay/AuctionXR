import Foundation
import SwiftUI

struct ArtifactsData: Identifiable, Codable {
    var id: UUID
    var title: String
    var description: String
    var startingPrice: Double
    var currentBid: Double
    var isSold: Bool
    var likes: [String]
    var dislikes: [String]
    var currentBidder: String
    var comments: Int
    var imageURL: URL
    var rating: Double
    var isBidded: Bool
    var bidEndTime: Date
    var imageURLs: [URL]
    var videoURLs: URL
    var category: String

    // Default initializer
    init(id: UUID = UUID(), title: String, description: String, startingPrice: Double, currentBid: Double, isSold: Bool, likes: [String], dislikes: [String], currentBidder: String, comments: Int, imageURL: URL, rating: Double,isBidded: Bool, bidEndTime: Date, imageURLs: [URL], videoURLs: URL, category: String) {
        self.id = id
        self.title = title
        self.description = description
        self.startingPrice = startingPrice
        self.currentBid = currentBid
        self.isSold = isSold
        self.likes = likes
        self.dislikes = dislikes
        self.currentBidder = currentBidder
        self.comments = comments
        self.imageURL = imageURL
        self.rating = rating
        self.isBidded = isBidded
        self.bidEndTime = bidEndTime
        self.imageURLs = imageURLs
        self.videoURLs = videoURLs
        self.category = category
    }
}
