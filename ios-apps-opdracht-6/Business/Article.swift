//
//  Article.swift
//  ios-apps-opdracht-6
//
//  Copyright © 2018 VIVES. All rights reserved.
//

import Foundation

struct Article {
    let id: String
    let description: String
    let minimumBidValue: Double
    var bids: [Bid]
}
