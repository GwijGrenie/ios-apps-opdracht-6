//
//  BidConverter.swift
//  ios-apps-opdracht-6
//
//  Copyright © 2018 VIVES. All rights reserved.
//

import Foundation
import Firebase

class BidExtractor: DataExtractorProtocol {
    
    typealias T = Bid
    
    func extractElement(_ documentSnapshot: DocumentSnapshot) -> Bid? {
        
        var id: String
        var value: Double
        var date: Date
        var memberId: String
        
        guard let data: [String: Any] = documentSnapshot.data() else {
            return nil
        }
        
        id = documentSnapshot.documentID
        
        /*
        
        if let parsedValue = ParseHelper.parseToDouble(data["value"] as! CFNumber) {
            value = parsedValue
        } else {
            value = 0
        }
 
         */
        
        value = 0
        
        let timestamp: Timestamp = data["date"] as! Timestamp
        date = timestamp.dateValue()
        
        memberId = data["memberId"] as! String
        
        return Bid(id: id, value: value, date: date, memberId: memberId)
    }
}
