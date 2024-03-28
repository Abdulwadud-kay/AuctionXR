import FirebaseAuth
import FirebaseFirestore
import SwiftUI
import Combine

class ArtifactsViewModel: ObservableObject {
    @Published var artifacts: [ArtifactsData]? = []
    @Published var drafts: [ArtifactsData]? = []
    @Published var selectedSegment: Int = 0
    
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
        let userDocRef = db.collection("users").document(userID)
        let collectionRef = userDocRef.collection(collection) // Reference to the nested collection
        
        collectionRef.getDocuments { [weak self] (snapshot, error) in
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
            
            var fetchedArtifacts: [ArtifactsData] = []
            
            for document in documents {
                do {
                    var artifact = try document.data(as: ArtifactsData.self) // Declare as 'var'
                    // Ensure that necessary fields are present and handle missing or null values
                    artifact.rating = artifact.rating ?? 0.0
                    fetchedArtifacts.append(artifact)
                } catch {
                    print("Error decoding document: \(error)")
                }
            }

            
            // Update the appropriate property based on the collection type
            if collection == "drafts" {
                self.drafts = fetchedArtifacts
            } else {
                self.artifacts = fetchedArtifacts
            }
            
            completion(true)
        }
    }


    func removeArtifactFromDrafts(artifactID: String) {
        guard let currentUser = Auth.auth().currentUser else {
            print("User is not logged in")
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(currentUser.uid)
        let draftRef = userRef.collection("drafts").document(artifactID)
        
        draftRef.delete { error in
            if let error = error {
                print("Error deleting artifact from drafts: \(error.localizedDescription)")
            } else {
                print("Artifact successfully removed from drafts")
                // Optionally, trigger a reload or update UI here
            }
        }
    }
    
    func calculateStarRating(from price: Double) -> Double {
        // Example: Every 100 increases the rating by 1 star, allowing fractional values
        return min(max(0.5, price / 100), 5)
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
    func getUsernameFromUserID(userID: String, completion: @escaping (String?) -> Void) {
        if let currentUser = Auth.auth().currentUser {
            // If the current user is available, check if it matches the requested userID
            if currentUser.uid == userID {
                // If the userID matches the current user's ID, return the current user's display name
                completion(currentUser.displayName)
            } else {
                // If the requested userID is different, query the Firestore users collection to get the username
                let db = Firestore.firestore()
                let userRef = db.collection("users").document(userID)
                
                userRef.getDocument { document, error in
                    if let document = document, document.exists {
                        if let username = document.data()?["username"] as? String {
                            // Username found in Firestore, return it
                            completion(username)
                        } else {
                            // Username not found in Firestore
                            completion(nil)
                        }
                    } else {
                        // Document not found in Firestore
                        completion(nil)
                    }
                }
            }
        } else {
            // If no user is signed in, return nil
            completion(nil)
        }
    }
}
