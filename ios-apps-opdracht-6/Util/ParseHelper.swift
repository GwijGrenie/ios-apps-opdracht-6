//
//  ConverterHelper.swift
//  ios-apps-opdracht-6
//
//  Copyright © 2018 VIVES. All rights reserved.
//

import Foundation

class ParseHelper {
    
    private init() {}
    
    static func parseToDouble(_ value: CFNumber) -> Double {
        var bidFloat: Float = 0
        if CFNumberGetValue(value, CFNumberType.floatType, &bidFloat ) {
            return Double(bidFloat) }
        else {
            return 0
        }
    }
}
