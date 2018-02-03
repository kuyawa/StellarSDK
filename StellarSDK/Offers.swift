//
//  Offers.swift
//  StellarSDK
//
//  Created by Laptop on 1/29/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Foundation

extension StellarSDK {
    
    open class Offers {
        // TODO:
    }
    
    open class OffersResponse {
        public var server    : Horizon?
        public var error     : ErrorMessage?
        public var raw       : String?
        //
        public var accountId : String = ""
        public var links     : Types.NavigationLinks?
        public var records   : [OfferResponse] = []
        
        init() {}
        
        init(_ json: JsonType) {
            if  let list = json["_links"]    as? JsonType { links = Types.NavigationLinks(list) }
            if  let list = json["_embedded"] as? JsonType,
                let recs = list["records"]   as? JsonList {
                for item in recs {
                    if let temp = item as? JsonType { records.append(OfferResponse(temp)) }
                }
                
            }
        }
    }
    
    open class OfferResponse {
        public var links       : OfferLinks?
        public var id          : Int?
        public var pagingToken : String?
        public var seller      : String?
        public var selling     : Types.Asset?
        public var buying      : Types.Asset?
        public var price       : String?
        public var priceRate   : Types.PriceRate?
        public var amount      : String?
        
        
        init(_ json: JsonType) {
            if let list = json["_links"]  as? JsonType { links     = OfferLinks(list) }
            if let list = json["selling"] as? JsonType { selling   = Types.Asset(list) }
            if let list = json["buying"]  as? JsonType { buying    = Types.Asset(list) }
            if let list = json["price_r"] as? JsonType { priceRate = Types.PriceRate(list) }

            id           = json["id"]           as? Int ?? 0
            pagingToken  = json["paging_token"] as? String
            seller       = json["seller"]       as? String
            amount       = json["amount"]       as? String
            price        = json["price"]        as? String
        }
    }
    
    public struct OfferLinks {
        public var myself     : Types.Link?
        public var offerMaker : Types.Link?
        
        init(_ json: JsonType) {
            if let link = json["self"]        as? JsonType { myself     = Types.Link(link) }
            if let link = json["offer_maker"] as? JsonType { offerMaker = Types.Link(link) }
        }
    }
    
}
