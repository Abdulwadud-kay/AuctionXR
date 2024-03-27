import SwiftUI
import Firebase

struct HistoryView: View {
    @EnvironmentObject var userAuthManager: UserManager
    @State private var soldArtifacts: [ArtifactsData] = []

    var body: some View {
        List(soldArtifacts, id: \.id) { artifact in
            VStack(alignment: .leading) {
                Text(artifact.title)
                    .font(.headline)
                if let currentBid = artifact.currentBid {
                    Text("Sold for $\(currentBid, specifier: "%.2f")")
                        .font(.subheadline)
                } else {
                    Text("Sold for Unknown Price")
                        .font(.subheadline)
                }
                if let bidEndDate = artifact.bidEndDate {
                    Text("\(formatDate(bidEndDate))")
                        .font(.subheadline)
                } else {
                    Text("Bid End Date Unknown")
                        .font(.subheadline)
                }
            }
        }
        .navigationBarTitle("Transactions")
        .onAppear {
            fetchSoldArtifacts()
        }
    }

    private func fetchSoldArtifacts() {
        let db = Firestore.firestore()
        let userId = Auth.auth().currentUser?.uid ?? ""
        
        db.collection("artifacts")
            .whereField("userId", isEqualTo: userId)
            .whereField("isSold", isEqualTo: true)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error fetching sold artifacts: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No documents found")
                    return
                }
                
                self.soldArtifacts = documents.compactMap { document in
                    do {
                        let artifact = try document.data(as: ArtifactsData.self)
                        return artifact
                    } catch {
                        print("Error decoding artifact: \(error.localizedDescription)")
                        return nil
                    }
                }
            }
    }

    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter.string(from: date)
    }

}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
