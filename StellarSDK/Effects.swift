//
//  Effects.swift
//  StellarSDK
//
//  Created by Laptop on 1/29/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Foundation

extension StellarSDK {
    
    open class Effects {
        // TODO:
    }
    
    open class EffectsResponse {
        public var server    : Horizon?
        public var error     : ErrorMessage?
        public var raw       : String?
        //
        public var accountId : String = ""
        public var links     : Types.NavigationLinks?
        public var records   : [EffectResponse] = []
        
        init() {}
        
        init(_ json: JsonType) {
            if  let list = json["_links"]    as? JsonType { links = Types.NavigationLinks(list) }
            if  let list = json["_embedded"] as? JsonType,
                let recs = list["records"]   as? JsonList {
                for item in recs {
                    if let temp = item as? JsonType { records.append(EffectResponse(temp)) }
                }
                
            }
        }
    }

    open class EffectResponse {
        public var links        : EffectLinks?
        public var id           : String?
        public var pagingToken  : String?
        public var account      : String?
        public var type         : String?
        public var typeInt      : Int = 0
        public var assetType    : String?
        public var assetCode    : String?
        public var assetIssuer  : String?
        public var amount       : String?


        init(_ json: JsonType) {
            if let list = json["_links"] as? JsonType { links = EffectLinks(list) }
            
            id                   = json["id"]                     as? String
            pagingToken          = json["paging_token"]           as? String
            account              = json["account"]                as? String
            type                 = json["type"]                   as? String
            typeInt              = json["type_i"]                 as? Int ?? 0
            assetType            = json["asset_type"]             as? String
            assetCode            = json["asset_code"]             as? String
            assetIssuer          = json["asset_issuer"]           as? String
            amount               = json["amount"]                 as? String
        }
    }
    
    public struct EffectLinks {
        public var operations : Types.Link?
        public var succeeds   : Types.Link?
        public var precedes   : Types.Link?

        init(_ json: JsonType) {
            if let link = json["operations"] as? JsonType { operations = Types.Link(link) }
            if let link = json["succeeds"]   as? JsonType { succeeds   = Types.Link(link) }
            if let link = json["precedes"]   as? JsonType { precedes   = Types.Link(link) }
        }
    }

}
