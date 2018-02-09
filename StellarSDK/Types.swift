//
//  Types.swift
//  StellarSDK
//
//  Created by Laptop on 1/27/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Foundation

// Old definitions before using StellarTypes.x

extension StellarSDK {

    public typealias JsonType = [String: Any?]
    public typealias JsonList = [Any?]

    open class Types {

        open class Operations {
            
            open class CreateAccount {
                var source      = ""
                var destination = ""
                var balance     = 0.0
                
                init() {}
                
                func toXDR() -> Data {
                    return Data()
                }
                
            }
            
            open class Payment {
                var source  = ""
                var target  = ""
                var asset   = ""
                var amount  = 0.0
                
                init() {}
                
                func toXDR() -> Data {
                    return Data()
                }
            }
            
            open class PathPayment {
                // TODO:
            }
            
            open class ManageOffer {
                // TODO:
            }
            
            open class CreatePassiveOffer {
                // TODO:
            }
            
            open class SetOptions {
                // TODO:
            }
            
            open class ChangeTrust {
                // TODO:
            }
            
            open class AllowTrust {
                // TODO:
            }
            
            open class AccountMerge {
                // TODO:
            }
            
            open class Inflation {
                // TODO: 
            }
            
            open class ManageData { 
                // TODO: 
            }


        }
        
        public struct Link {
            public var url: String
            public var templated: Bool = false
            
            public init(_ json: JsonType) {
                url = json["href"] as! String
                if let temp = json["templated"] as? Bool {
                    templated = temp
                }
            }
        }

        public struct NavigationLinks {
            public var myself : Types.Link?
            public var next   : Types.Link?
            public var prev   : Types.Link?

            public init(_ json: JsonType) {
                if let link = json["self"] as? JsonType { myself = Types.Link(link) }
                if let link = json["next"] as? JsonType { next   = Types.Link(link) }
                if let link = json["prev"] as? JsonType { prev   = Types.Link(link) }
            }
        }
        
        public struct Thresholds {
            public var low  : Int = 0
            public var med  : Int = 0
            public var high : Int = 0
            
            public init(_ json: JsonType) {
                if let num = json["low_threshold"]  as? Int { low  = num }
                if let num = json["mid_threshold"]  as? Int { med  = num }
                if let num = json["high_threshold"] as? Int { high = num }
            }
        }
        
        public struct Flags {
            public var authRequired  : Bool = false
            public var authRevocable : Bool = false
            public var authImmutable : Bool = false

            public init(_ json: JsonType) {
                if let flag = json["auth_required"]  as? Bool { authRequired  = flag }
                if let flag = json["auth_revocable"] as? Bool { authRevocable = flag }
                if let flag = json["auth_immutable"] as? Bool { authImmutable = flag }
            }
        }
        
        public struct Balance {
            public var balance     : String = ""
            public var limit       : String = ""
            public var assetType   : String = "native"
            public var assetCode   : String = "XLM"
            public var assetIssuer : String = ""

            public init(_ json: JsonType) {
                if let str = json["balance"]      as? String { balance     = str }
                if let str = json["limit"]        as? String { limit       = str }
                if let str = json["asset_type"]   as? String { assetType   = str }
                if let str = json["asset_code"]   as? String { assetCode   = str } else { assetCode = "XLM" }
                if let str = json["asset_issuer"] as? String { assetIssuer = str }
            }
        }
        
        public struct Signer {
            public var publicKey : String?
            public var weight    : Int = 0
            public var key       : String?
            public var type      : String = "ed25519_public_key"

            public init(_ json: JsonType) {
                if let str = json["public_key"] as? String { publicKey = str }
                if let num = json["weight"]     as? Int    { weight    = num }
                if let str = json["key"]        as? String { key       = str }
                if let str = json["type"]       as? String { type      = str }
            }

        }
        
        public struct Asset {
            public var assetType   : String?
            public var assetCode   : String?
            public var assetIssuer : String?

            public init(_ json: JsonType) {
                if let str = json["asset_type"]   as? String { assetType   = str }
                if let str = json["asset_code"]   as? String { assetCode   = str }
                if let str = json["asset_issuer"] as? String { assetIssuer = str }
            }
        }
        
        public struct PriceRate {
            public var numerator   : Int?
            public var denominator : Int?

            public init(_ json: JsonType) {
                if let num = json["n"] as? Int { numerator   = num }
                if let den = json["d"] as? Int { denominator = den }
            }
        }
        
        public struct DataPair {
            public var key   : String
            public var value : String
        }
        
       
    }
    
}
