import Firebase
import FirebaseFirestore
import SwiftUI

class ArtifactsViewModel: ObservableObject {
    @Published var artifacts: [ArtifactsData]? = []


    func fetchArtifacts(userID: String, completion: @escaping (Bool) -> Void) {
        print("Fetching artifacts for user: \(userID)")
        fetchData(from: "posts", userID: userID) { success in
            print("fetch post completed: \(success)")
            completion(success)
        }
    }

    func fetchDrafts(userID: String, completion: @escaping (Bool) -> Void) {
        print("Fetching drafts for user: \(userID)")
        fetchData(from: "drafts", userID: userID) { success in
            print("fetch Drafts completed: \(success)")
            completion(success)
        }
    }



    func fetchAllArtifacts(completion: @escaping (Bool) -> Void) {
        print("Fetching all artifacts")
        fetchData(from: "posts", userID: "") { success in
            print("fetchAllArtifacts completed: \(success)")
            completion(success)
        }
    }


    private func fetchData(from collection: String, userID: String, completion: @escaping (Bool) -> Void) {
        print("Fetching data from collection: \(collection), userID: \(userID)")

        let db = Firestore.firestore()
        let collectionRef = db.collection(collection)
        var query: Query = collectionRef // Assign query as a Query

        if !userID.isEmpty {
            query = collectionRef.whereField("userId", isEqualTo: userID)
        }

        query.getDocuments { [weak self] (snapshot, error) in
            guard let self = self else { return }

            if let error = error {
                print("Error fetching \(collection): \(error)")
                completion(false) // Call completion handler with failure
                return
            }

            guard let documents = snapshot?.documents else {
                print("No \(collection) documents found")
                completion(false) // Call completion handler with failure
                return
            }

            print("Fetched \(documents.count) documents from collection: \(collection)")

            // Convert documents to artifacts data
            self.artifacts = documents.compactMap { document -> ArtifactsData? in
                do {
                    var artifact = try document.data(as: ArtifactsData.self)

                    // Fetch likes and dislikes counts
                    print("Fetching likes and dislikes for artifact: \(artifact)")
                    self.fetchLikesAndDislikes(for: document.reference) { likes, dislikes in
                        artifact.likes = likes // Remove optional chaining
                        artifact.dislikes = dislikes // Remove optional chaining
                        artifact.rating = self.calculateStarRating(from: artifact.currentBid ?? 0.0) // Remove optional chaining and provide a default value
                    }

                    return artifact
                } catch {
                    print("Error decoding document: \(error)")
                    return nil
                }
            }

            completion(true) // Call completion handler with success
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
    func updateArtifact(_ artifacts: [ArtifactsData]) {
            self.artifacts = artifacts
        }
}
