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

public struct ErrorMessage {
    public var code : Int    = 0
    public var text : String = ""
}

public enum SortOrder {
    case asc
    case desc
}

public struct ListOptions {
    public var cursor : String    = ""
    public var limit  : Int       = 10
    public var order  : SortOrder = .desc
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
