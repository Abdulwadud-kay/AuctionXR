
import Foundation
import SwiftUI

struct ArtifactsData: Identifiable, Codable {
    var id: UUID
    var title: String
    var description: String
    var startingPrice: Double
    var currentBid: Double
    var isSold: Bool
    var likes: [String]?
    var dislikes: [String]?
    var currentBidder: String
    var imageURL: URL
    var rating: Double
    var isBidded: Bool
    var bidEndTime: Date
    var imageURLs: [URL]
    var videoURL: [URL]
    var category: String

    // Default initializer
    init(id: UUID = UUID(), title: String, description: String, startingPrice: Double, currentBid: Double, isSold: Bool, likes: [String]? = nil, dislikes: [String]? = nil, currentBidder: String, imageURL: URL, rating: Double,isBidded: Bool, bidEndTime: Date, imageURLs: [URL], videoURL: [URL], category: String) {
        self.id = id
        self.title = title
        self.description = description
        self.startingPrice = startingPrice
        self.currentBid = currentBid
        self.isSold = isSold
        self.likes = likes
        self.dislikes = dislikes
        self.currentBidder = currentBidder
        self.imageURL = imageURL
        self.rating = rating
        self.isBidded = isBidded
        self.bidEndTime = bidEndTime
        self.imageURLs = imageURLs
        self.videoURL = videoURL
        self.category = category
    }
}
