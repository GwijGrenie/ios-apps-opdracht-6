//
//  BidConverter.swift
//  ios-apps-opdracht-6
//
//  Copyright © 2018 VIVES. All rights reserved.
//

import Foundation

class BidConverter: Converter {
    typealias T = Bid
    
    func convert(_ data: [String : Any]) -> (result: Bid, error: String?) {
        
        let id: String = data["id"] as! String
        
        
    }
}
