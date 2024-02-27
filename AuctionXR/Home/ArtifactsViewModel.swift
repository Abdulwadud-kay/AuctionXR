import Firebase
import SwiftUI

class ArtifactsViewModel: ObservableObject {
    @Published var artifacts = [ArtifactsData]()

    init() {
        fetchArtifacts()
    }

    func fetchArtifacts() {
        let db = Firestore.firestore()
        db.collection("posts").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("No documents")
                return
            }

            documents.forEach { doc in
                do {
                    // Convert the document data to JSON Data
                    let jsonData = try JSONSerialization.data(withJSONObject: doc.data(), options: [])
                    // Decode the JSON data to an ArtifactsData object
                    var artifact = try JSONDecoder().decode(ArtifactsData.self, from: jsonData)

                    // Fetch likes and dislikes counts
                    let group = DispatchGroup()

                    group.enter()
                    doc.reference.collection("likes").getDocuments { snapshot, _ in
                        artifact.likes = snapshot?.documents.map { $0.documentID } ?? []
                        group.leave()
                    }

                    group.enter()
                    doc.reference.collection("dislikes").getDocuments { snapshot, _ in
                        artifact.dislikes = snapshot?.documents.map { $0.documentID } ?? []
                        group.leave()
                    }


                    group.notify(queue: .main) {
                        // Calculate star rating based on price
                        artifact.rating = self.calculateStarRating(from: artifact.currentBid)

                        self.artifacts.append(artifact)
                    }
                } catch {
                    print("Error decoding document: \(error)")
                }
            }
        }
    }
    func calculateStarRating(from price: Double) -> Double {
        // Example: Every 100 increases the rating by 1 star, allowing fractional values
        return min(max(0.5, price / 100), 5)
    }

        
        func updateLike(for artifactID: String, userID: String) {
            // Path to the specific artifact in Firestore
            let artifactRef = Firestore.firestore().collection("posts").document(artifactID)

            // Check if the user has already liked this artifact
            artifactRef.collection("likes").document(userID).getDocument { (document, error) in
                if let document = document, document.exists {
                    // User has already liked, so unlike it
                    artifactRef.collection("likes").document(userID).delete()
                } else {
                    // User has not liked, so add like
                    artifactRef.collection("likes").document(userID).setData(["liked": true])
                    // Optionally, remove dislike if existed
                    artifactRef.collection("dislikes").document(userID).delete()
                }
            }
        }

        func updateDislike(for artifactID: String, userID: String) {
            let artifactRef = Firestore.firestore().collection("posts").document(artifactID)

            artifactRef.collection("dislikes").document(userID).getDocument { (document, error) in
                if let document = document, document.exists {
                    artifactRef.collection("dislikes").document(userID).delete()
                } else {
                    artifactRef.collection("dislikes").document(userID).setData(["disliked": true])
                    artifactRef.collection("likes").document(userID).delete()
                }
            }
        }

    }

