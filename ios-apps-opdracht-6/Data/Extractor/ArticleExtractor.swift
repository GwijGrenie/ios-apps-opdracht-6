//
//  ArticleConverter.swift
//  ios-apps-opdracht-6
//
//  Copyright © 2018 VIVES. All rights reserved.
//

import Foundation
import Firebase

class ArticleExtractor: DataExtractorProtocol {
    
    typealias T = Article
    
    func extractElement(_ documentSnapshot: DocumentSnapshot) -> Article? {
        
        var id: String
        var description: String
        var minimumBidValue: Double
        
        guard let data: [String: Any] = documentSnapshot.data() else {
            return nil
        }
        
        id = documentSnapshot.documentID
        
        description = data["description"] as! String
        
        let b:CFNumber = data["minimumBidValue"] as! CFNumber
        var bidFloat :Float = 0
        if CFNumberGetValue(b, CFNumberType.floatType,&bidFloat ) {
            minimumBidValue = Double(bidFloat) } else {
            minimumBidValue = 0 }
        
        return Article(id: id,  description: description, minimumBidValue: minimumBidValue, bids: [Bid]())
    }
}
