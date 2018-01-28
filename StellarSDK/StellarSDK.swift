//
//  StellarSDK.swift
//  StellarSDK
//
//  Created by Laptop on 1/24/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Foundation

public typealias Callback   = (_ response: Response) -> Void
public typealias Parameters = [String: Any?]

struct ErrorMessage {
    var code : Int    = 0
    var text : String = ""
}

enum SortOrder {
    case asc
    case desc
}

public struct ListOptions {
    var cursor : String    = ""
    var limit  : Int       = 10
    var order  : SortOrder = .desc
}


open class StellarSDK {
    
    static func usePublicNetwork() -> Horizon {
        return Horizon(.live)
    }
    
    static func useTestNetwork() -> Horizon {
        return Horizon(.test)
    }
    
    class Memo {
        static func text(_ text: String) -> String {
            return ""
        }
    }
    
}
