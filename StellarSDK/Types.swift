//
//  Types.swift
//  StellarSDK
//
//  Created by Laptop on 1/27/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Foundation

extension StellarSDK {

    typealias JsonType = [String: Any?]
    typealias JsonList = [Any?]
    
    open class Types {

        struct Link {
            var url: String
            var templated: Bool = false
            
            init(_ json: JsonType) {
                url = json["href"] as! String
                if let temp = json["templated"] as? Bool {
                    templated = temp
                }
            }
        }

        struct NavigationLinks {
            var myself : Types.Link?
            var next   : Types.Link?
            var prev   : Types.Link?

            init(_ json: JsonType) {
                if let link = json["self"] as? JsonType { myself = Types.Link(link) }
                if let link = json["next"] as? JsonType { next   = Types.Link(link) }
                if let link = json["prev"] as? JsonType { prev   = Types.Link(link) }
            }
        }
        
        struct AccountLinks {
            var myself       : Types.Link?
            var transactions : Types.Link?
            var operations   : Types.Link?
            var payments     : Types.Link?
            var effects      : Types.Link?
            var offers       : Types.Link?
            var trades       : Types.Link?
            var data         : Types.Link?
            
            init(_ json: JsonType) {
                if let link = json["self"]         as? JsonType { myself       = Types.Link(link) }
                if let link = json["transactions"] as? JsonType { transactions = Types.Link(link) }
                if let link = json["operations"]   as? JsonType { operations   = Types.Link(link) }
                if let link = json["payments"]     as? JsonType { payments     = Types.Link(link) }
                if let link = json["effects"]      as? JsonType { effects      = Types.Link(link) }
                if let link = json["offers"]       as? JsonType { offers       = Types.Link(link) }
                if let link = json["trades"]       as? JsonType { trades       = Types.Link(link) }
                if let link = json["data"]         as? JsonType { data         = Types.Link(link) }
            }
        }
        
        struct TransactionLinks {
            var myself       : Types.Link?
            var account      : Types.Link?
            var ledger       : Types.Link?
            var operations   : Types.Link?
            var effects      : Types.Link?
            var precedes     : Types.Link?
            var succeeds     : Types.Link?
            
            init(_ json: JsonType) {
                if let link = json["self"]         as? JsonType { myself     = Types.Link(link) }
                if let link = json["account"]      as? JsonType { account    = Types.Link(link) }
                if let link = json["ledger"]       as? JsonType { ledger     = Types.Link(link) }
                if let link = json["operations"]   as? JsonType { operations = Types.Link(link) }
                if let link = json["effects"]      as? JsonType { effects    = Types.Link(link) }
                if let link = json["precedes"]     as? JsonType { precedes   = Types.Link(link) }
                if let link = json["succeeds"]     as? JsonType { succeeds   = Types.Link(link) }
            }
        }
        
        struct Thresholds {
            var low  : Int = 0
            var med  : Int = 0
            var high : Int = 0
            
            init(_ json: JsonType) {
                if let num = json["low_threshold"]  as? Int { low  = num }
                if let num = json["mid_threshold"]  as? Int { med  = num }
                if let num = json["high_threshold"] as? Int { high = num }
            }
        }
        
        struct Flags {
            var authRequired  : Bool = false
            var authRevocable : Bool = false

            init(_ json: JsonType) {
                if let flag = json["auth_required"]  as? Bool { authRequired  = flag }
                if let flag = json["auth_revocable"] as? Bool { authRevocable = flag }
            }
        }
        
        struct Balance {
            var balance   : String = ""
            var assetType : String = "native"

            init(_ json: JsonType) {
                if let str = json["balance"]    as? String { balance   = str }
                if let str = json["asset_type"] as? String { assetType = str }
            }
        }
        
        struct Signer {
            var publicKey : String?
            var weight    : Int = 0
            var key       : String?
            var type      : String = "ed25519_public_key"

            init(_ json: JsonType) {
                if let str = json["public_key"] as? String { publicKey = str }
                if let num = json["weight"]     as? Int    { weight    = num }
                if let str = json["key"]        as? String { key       = str }
                if let str = json["type"]       as? String { type      = str }
            }

        }
        
        struct DataPair {
            var key   : String
            var value : String
        }
        
       
    }
    
}
