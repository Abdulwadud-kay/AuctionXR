import Foundation
import SwiftUI

struct ArtifactsView: Identifiable, Codable {
    var id: UUID
    var title: String
    var description: String
    var startingPrice: Double
    var currentBid: Double
    var previousBid: Double
    var isSold: Bool
    var likes: Int
    var dislikes: Int
    var currentBidder: String
    var timeRemaining: TimeInterval
    var comments: Int
    var imageName: String
    var rating: Double
    var isBidded: Bool
    var bidEndTime: Date

    // Default initializer
    init(id: UUID = UUID(), title: String, description: String, startingPrice: Double, currentBid: Double, previousBid: Double, isSold: Bool, likes: Int, dislikes: Int, currentBidder: String, timeRemaining: TimeInterval, comments: Int, imageName: String, rating: Double,isBidded: Bool, bidEndTime: Date) {
        self.id = id
        self.title = title
        self.description = description
        self.startingPrice = startingPrice
        self.currentBid = currentBid
        self.previousBid = previousBid
        self.isSold = isSold
        self.likes = likes
        self.dislikes = dislikes
        self.currentBidder = currentBidder
        self.timeRemaining = timeRemaining
        self.comments = comments
        self.imageName = imageName
        self.rating = rating
        self.isBidded = isBidded
        self.bidEndTime = bidEndTime
    }
}
