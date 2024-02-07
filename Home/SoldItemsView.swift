//
//  SoldItemsView.swift
//  GoTwice
//
//  Created by Abdulwadud Abdulkadir on 1/13/24.
//

import Foundation
import SwiftUI

struct SoldItemsView: View {
    // Expanded data model to include an 'isSold' flag
    let items = [
        Item(title: "Vintage Clock", price: 150.00, buyer: "Alice", isSold: true),
        Item(title: "Antique Painting", price: 300.00, buyer: "Bob", isSold: false)
    ]

    var body: some View {
        List(items, id: \.title) { item in
            VStack(alignment: .leading) {
                Text(item.title)
                    .font(.headline)
                Text("\(item.isSold ? "Sold" : "Bought") for $\(item.price, specifier: "%.2f")")
                    .font(.subheadline)
                Text(item.isSold ? "Buyer: \(item.buyer)" : "Seller: \(item.buyer)")
                    .font(.subheadline)
            }
        }
        .navigationBarTitle("Transactions")
    }
}

struct Item {
    let title: String
    let price: Double
    let buyer: String // Could be 'seller' or 'buyer' based on the context
    let isSold: Bool  // True if sold, false if bought
}

struct SoldItemsView_Previews: PreviewProvider {
    static var previews: some View {
        SoldItemsView()
    }
}
