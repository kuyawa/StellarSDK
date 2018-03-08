//
//  Utils.swift
//  StellarSDK
//
//  Created by Laptop on 1/23/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Foundation


extension String {
    var dataUTF8: Data? { return self.data(using: .utf8) }

    var urlEncoded: String {
        var allowedQueryParamAndKey = NSMutableCharacterSet.urlQueryAllowed
        allowedQueryParamAndKey.remove(charactersIn: ";/?:@&=+$, ")
        
        return self.addingPercentEncoding(withAllowedCharacters: allowedQueryParamAndKey)!  // TODO: Guard
        //return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
}

extension Sequence where Iterator.Element == UInt8 {
    public var base32: String {
        let bytes = Array(self)
        return base32Encode(bytes)
    }
}

extension Sequence where Iterator.Element == UInt8 {
    public var data: Data {
        let bytes = Array(self)
        return Data(bytes: bytes)
    }
}

extension Bool {
    var byte: UInt8 { return self ? 0x1 : 0x0 }
}

extension Double {
    var decs: Int {
        let text  = String(self)
        let trim  = text.trimmingCharacters(in: CharacterSet(charactersIn: "0"))
        let split = trim.components(separatedBy: ".")
        if split.count > 0 {
            return split[1].characters.count
        }
        return 0
    }
}


// Simplify fractions
func simplify(_ num: Int32, _ den: Int32) -> (Int32, Int32) {
    var x = num
    var y = den
    
    while (y != 0) {
        let buffer = y
        y = x % y
        x = buffer
    }
    
    let hcfVal = x
    let newNum: Int32 = (num / hcfVal)
    let newDen: Int32 = (den / hcfVal)
    
    return (newNum, newDen)
}


// END
