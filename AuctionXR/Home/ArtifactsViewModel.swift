import FirebaseAuth
import FirebaseFirestore
import SwiftUI

class ArtifactsViewModel: ObservableObject {
    @Published var artifacts: [ArtifactsData]? = []
    
    func fetchDrafts(userID: String, completion: @escaping (Bool) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            print("User is not logged in")
            completion(false)
            return
        }
        
        print("Fetching drafts for user: \(userID)")
        fetchData(from: "drafts", userID: userID) { success in
            print("fetch Drafts completed: \(success)")
            completion(success)
        }
    }
    
    func fetchAllArtifacts(completion: @escaping (Bool) -> Void) {
        // Access Firestore reference
        let db = Firestore.firestore()
        
        // Get the current user's ID
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("User is not logged in")
            completion(false)
            return
        }
        
        // Access the "users" collection and then the specific user's document
        let userDocRef = db.collection("users").document(currentUserID)
        
        // Fetch all documents from the "posts" subcollection of the user's document
        userDocRef.collection("posts").getDocuments { [weak self] (snapshot, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching artifacts: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            // Process fetched documents
            guard let documents = snapshot?.documents else {
                print("No artifacts found")
                completion(false)
                return
            }
            
            // Map documents to ArtifactsData objects
            let artifacts = documents.compactMap { document -> ArtifactsData? in
                do {
                    return try document.data(as: ArtifactsData.self)
                } catch {
                    print("Error decoding document: \(error.localizedDescription)")
                    return nil
                }
            }
            
            // Update viewModel's artifacts property
            self.artifacts = artifacts
            
            // Call completion with success
            completion(true)
        }
    }

    
    func fetchArtifacts(userID: String, completion: @escaping (Bool) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            print("User is not logged in")
            completion(false)
            return
        }
        
        print("Fetching artifacts for user: \(userID)")
        fetchData(from: "posts", userID: userID) { success in
            print("fetch post completed: \(success)")
            completion(success)
        }
    }

    private func fetchData(from collection: String, userID: String, completion: @escaping (Bool) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            print("User is not logged in")
            completion(false)
            return
        }
        
        // Proceed with fetching data since the user is logged in
        print("Fetching data from collection: \(collection), userID: \(userID)")
        
        let db = Firestore.firestore()
        let collectionRef = db.collection(collection)
        var query: Query = collectionRef
        
        if !userID.isEmpty {
            // Adjust the query to fetch posts belonging to the specified user ID
            query = collectionRef.whereField("userID", isEqualTo: userID)
        }
        
        query.getDocuments { [weak self] (snapshot, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching \(collection): \(error)")
                completion(false)
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No \(collection) documents found")
                completion(false)
                return
            }
            
            print("Fetched \(documents.count) documents from collection: \(collection)")
            
            self.artifacts = documents.compactMap { document -> ArtifactsData? in
                do {
                    var artifact = try document.data(as: ArtifactsData.self)
                    
                    // Ensure that necessary fields are present and handle missing or null values
                    artifact.likes = artifact.likes ?? []
                    artifact.dislikes = artifact.dislikes ?? []
                    artifact.rating = artifact.rating ?? 0.0
                    
                    return artifact
                } catch {
                    print("Error decoding document: \(error)")
                    return nil
                }
            }
            
            completion(true)
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
    func updateFirebaseDatabaseWithBid(artifactID: String, bidAmount: Double, bidderUsername: String) {
        let db = Firestore.firestore()
        let artifactRef = db.collection("posts").document(artifactID)
        
        artifactRef.getDocument { (document, error) in
            if let document = document, document.exists {
                var data = document.data() ?? [:]
                if let currentBid = data["currentBid"] as? Double {
                    // Check if the new bid amount is higher than the current bid
                    if bidAmount > currentBid {
                        // Update current bid and bidder fields
                        data["currentBid"] = bidAmount
                        data["currentBidder"] = bidderUsername
                    }
                } else {
                    // Initialize current bid and bidder fields
                    data["currentBid"] = bidAmount
                    data["currentBidder"] = bidderUsername
                }
                
                // Update the artifact document with the new bid information
                artifactRef.setData(data) { error in
                    if let error = error {
                        print("Error updating artifact document: \(error.localizedDescription)")
                    } else {
                        print("Artifact document updated successfully with bid information")
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
    }
}
