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



// END
