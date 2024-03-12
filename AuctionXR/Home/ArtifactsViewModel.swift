import Firebase
import SwiftUI

class ArtifactsViewModel: ObservableObject {
    @Published var artifacts: [ArtifactsData]? = []


    init() {
        fetchArtifacts(userID: "")
    }

    func fetchArtifacts(userID: String) {
        fetchData(from: "posts", userID: userID)
    }

    func fetchDrafts(userID: String) {
        fetchData(from: "drafts", userID: userID)
    }



    private func fetchData(from collection: String, userID: String) {
        let db = Firestore.firestore()
        db.collection(collection).getDocuments { [weak self] (snapshot, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching \(collection): \(error)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No \(collection) documents found")
                return
            }
            
            documents.forEach { document in
                do {
                    if let artifact = try? document.data(as: ArtifactsData.self) {
                        // Fetch likes and dislikes counts
                        self.fetchLikesAndDislikes(for: document.reference) { likes, dislikes in
                            if let artifactIndex = self.artifacts?.firstIndex(where: { $0.id == artifact.id }) {
                                self.artifacts?[artifactIndex].likes = likes
                                self.artifacts?[artifactIndex].dislikes = dislikes
                                self.artifacts?[artifactIndex].rating = self.calculateStarRating(from: artifact.currentBid)
                            } else {
                                print("Artifact with ID \(artifact.id) not found in artifacts")
                            }
                        }
                    } else {
                        print("Document \(document.documentID) does not contain valid data")
                    }
                } catch {
                    print("Error decoding document: \(error)")
                }
            }
        }
    }

    private func fetchLikesAndDislikes(for reference: DocumentReference, completion: @escaping ([String], [String]) -> Void) {
        let group = DispatchGroup()

        var likes: [String] = []
        var dislikes: [String] = []

        group.enter()
        reference.collection("likes").getDocuments { snapshot, error in
            defer { group.leave() }
            if let error = error {
                print("Error fetching likes: \(error)")
            } else {
                likes = snapshot?.documents.map { $0.documentID } ?? []
            }
        }

        group.enter()
        reference.collection("dislikes").getDocuments { snapshot, error in
            defer { group.leave() }
            if let error = error {
                print("Error fetching dislikes: \(error)")
            } else {
                dislikes = snapshot?.documents.map { $0.documentID } ?? []
            }
        }

        group.notify(queue: .main) {
            completion(likes, dislikes)
        }
    }

    func calculateStarRating(from price: Double) -> Double {
        // Example: Every 100 increases the rating by 1 star, allowing fractional values
        return min(max(0.5, price / 100), 5)
    }

    func updateLike(for artifactID: String, userID: String) {
        updateReaction(type: "likes", artifactID: artifactID, userID: userID)
    }

    func updateDislike(for artifactID: String, userID: String) {
        updateReaction(type: "dislikes", artifactID: artifactID, userID: userID)
    }

    private func updateReaction(type: String, artifactID: String, userID: String) {
        let artifactRef = Firestore.firestore().collection("posts").document(artifactID)

        artifactRef.collection(type).document(userID).getDocument { (document, error) in
            if let document = document, document.exists {
                artifactRef.collection(type).document(userID).delete()
            } else {
                artifactRef.collection(type).document(userID).setData([type == "likes" ? "liked" : "disliked": true])
                if type == "likes" {
                    artifactRef.collection("dislikes").document(userID).delete()
                } else {
                    artifactRef.collection("likes").document(userID).delete()
                }
            }
        }
    }
}
