//
//  Payments.swift
//  StellarSDK
//
//  Created by Laptop on 1/28/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Foundation

extension StellarSDK {
    
    open class Payment {
        //
    }
    
    open class PaymentsResponse {
        public var server    : Horizon?
        public var error     : ErrorMessage?
        public var raw       : String?
        //
        public var accountId : String = ""
        public var links     : Types.NavigationLinks?
        public var records   : [PaymentResponse] = []
        
        init() {}
        
        init(_ json: JsonType) {
            if  let list = json["_links"]    as? JsonType { links = Types.NavigationLinks(list) }
            if  let list = json["_embedded"] as? JsonType,
                let recs = list["records"]   as? JsonList {
                for item in recs {
                    if let temp = item as? JsonType { records.append(PaymentResponse(temp)) }
                }
                
            }
        }

    }

    open class PaymentResponse {
        public var links           : PaymentLinks?
        public var id              : String?
        public var pagingToken     : String?
        public var sourceAccount   : String?
        public var type            : String?
        public var typeInt         : Int = 0
        public var createdAt       : String?
        public var transactionHash : String?
        public var assetType       : String?
        public var assetCode       : String?
        public var assetIssuer     : String?
        public var from            : String?
        public var to              : String?
        public var amount          : String?


        init(_ json: JsonType) {
            if let list = json["_links"] as? JsonType { links = PaymentLinks(list) }
            
            id              = json["id"]               as? String
            pagingToken     = json["paging_token"]     as? String
            sourceAccount   = json["source_account"]   as? String
            type            = json["type"]             as? String
            typeInt         = json["type_i"]           as? Int ?? 0
            createdAt       = json["created_at"]       as? String
            transactionHash = json["transaction_hash"] as? String
            assetType       = json["asset_type"]       as? String
            assetCode       = json["asset_code"]       as? String
            assetIssuer     = json["asset_issuer"]     as? String
            from            = json["from"]             as? String
            to              = json["to"]               as? String
            amount          = json["amount"]           as? String
            
            if typeInt == 0 {
                from   = json["funder"] as? String
                to     = json["account"] as? String
                amount = json["starting_balance"] as? String
            }
        }
    }

    public struct PaymentLinks {
        public var myself       : Types.Link?
        public var transaction  : Types.Link?
        public var effects      : Types.Link?
        public var succeeds     : Types.Link?
        public var precedes     : Types.Link?
        
        init(_ json: JsonType) {
            if let link = json["self"]         as? JsonType { myself      = Types.Link(link) }
            if let link = json["transaction"]  as? JsonType { transaction = Types.Link(link) }
            if let link = json["effects"]      as? JsonType { effects     = Types.Link(link) }
            if let link = json["succeeds"]     as? JsonType { succeeds    = Types.Link(link) }
            if let link = json["precedes"]     as? JsonType { precedes    = Types.Link(link) }
        }
    }
    
}
