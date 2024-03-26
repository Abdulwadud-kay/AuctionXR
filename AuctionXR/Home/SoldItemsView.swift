import SwiftUI

struct SoldItemsView: View {
    @State private var selectedSegment = 0
    
    var body: some View {
        VStack {
            Picker(selection: $selectedSegment, label: Text("Select")) {
                Text("Bids").tag(0)
                Text("My Artifacts").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            // Content for each segment
            if selectedSegment == 0 {
                Text("Bids content goes here")
            } else {
                Text("My Artifacts content goes here")
            }
            
            Spacer()
        }
    }
}

struct SoldItemsView_Previews: PreviewProvider {
    static var previews: some View {
        SoldItemsView()
    }
}
