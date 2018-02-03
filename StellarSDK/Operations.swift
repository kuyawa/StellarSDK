//
//  Operations.swift
//  StellarSDK
//
//  Created by Laptop on 1/25/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Foundation

//protocol Operation {
//    func toXDR() -> Data
//}

// let op = StellarSDK.Operations.CreateAccount()

extension StellarSDK {
    
    public enum OperationType: Int {
        case CreateAccount       =  0
        case Payment             =  1
        case PathPayment         =  2
        case ManageOffer         =  3
        case CreatePassiveOffer  =  4
        case SetOptions          =  5
        case ChangeTrust         =  6
        case AllowTrust          =  7
        case AccountMerge        =  8
        case Inflation           =  9
        case ManageData          = 10
    }
    
    open class Operations {
        //
    }
    
    open class OperationsResponse {
        public var server    : Horizon?
        public var error     : ErrorMessage?
        public var raw       : String?
        //
        public var accountId : String = ""
        public var links     : Types.NavigationLinks?
        public var records   : [OperationResponse] = []
        
        init() {}
        
        init(_ json: JsonType) {
            if  let list = json["_links"]    as? JsonType { links = Types.NavigationLinks(list) }
            if  let list = json["_embedded"] as? JsonType,
                let recs = list["records"]   as? JsonList {
                for item in recs {
                    if let temp = item as? JsonType { records.append(OperationResponse(temp)) }
                }
                
            }
        }
        
    }
    
    open class OperationResponse {
        public var links                : OperationLinks?
        // Common
        public var id                   : String?
        public var pagingToken          : String?
        public var type                 : String?
        public var typeInt              : Int = 0
        public var sourceAccount        : String?
        public var createdAt            : String?
        public var transactionHash      : String?
        // Create Account
        public var account              : String?
        public var funder               : String?
        public var startingBalance      : String?
        // Payment
        public var from                 : String?
        public var to                   : String?
        public var amount               : String?
        public var assetType            : String?
        public var assetCode            : String?
        public var assetIssuer          : String?
        // Path Payment
        public var sourceAssetCode      : String?
        public var sourceAssetIssuer    : String?
        public var sourceAssetType      : String?
        public var sourceMax            : String?
        public var sourceAmount         : String?
        // Manage Offer / Create Passive Offer
        public var offerId              : Int?
        public var buyingAssetCode      : String?
        public var buyingAssetIssuer    : String?
        public var buyingAssetType      : String?
        public var price                : String?
        public var priceRate            : Types.PriceRate?
        public var sellingAssetCode     : String?
        public var sellingAssetIssuer   : String?
        public var sellingAssetType     : String?
        // Set Options
        public var signerKey	        : String?
        public var signerWeight	        : Int?
        public var masterKeyWeight	    : Int?
        public var lowThreshold	        : Int?
        public var medThreshold	        : Int?
        public var highThreshold	    : Int?
        public var homeDomain	        : String?
        public var setFlags	            : Array<Int>?
        public var setFlagsStr	        : Array<String>?
        public var clearFlags	        : Array<Int>?
        public var clearFlagsStr        : Array<String>?
        // Change Trust
        public var trustee  			: String?
        public var trustor  			: String?
        public var limit  			    : String?
        // Allow Trust
        public var authorize            : Bool?
        // Account Merge
        public var into                 : String?
        // Inflation
        // ?
        // Manage Data
        public var name                 : String?
        public var value                : String?
        
        public var typeText: String {
            switch typeInt {
            case  0: return "Create Account"
            case  1: return "Payment"
            case  2: return "Path Payment"
            case  3: return "Manage Offer"
            case  4: return "Passive Offer"
            case  5: return "Set Options"
            case  6: return "Change Trust"
            case  7: return "Allow Trust"
            case  8: return "Account Merge"
            case  9: return "Set Inflation"
            case 10: return "Manage Data"
            default: return "?"
            }
        }

        
        init(_ json: JsonType) {
            if let list = json["_links"]   as? JsonType { links = OperationLinks(list) }
            if let list = json["prices_r"] as? JsonType { priceRate = Types.PriceRate(list) }
            
            id                   = json["id"]                     as? String
            pagingToken          = json["paging_token"]           as? String
            type                 = json["type"]                   as? String
            typeInt              = json["type_i"]                 as? Int ?? 0
            sourceAccount        = json["source_account"]         as? String
            createdAt            = json["created_at"]             as? String
            transactionHash      = json["transaction_hash"]       as? String
            assetType            = json["asset_type"]             as? String
            account              = json["account"]                as? String
            funder               = json["funder"]                 as? String
            startingBalance      = json["starting_balance"]       as? String
            from                 = json["from"]                   as? String
            to                   = json["to"]                     as? String
            amount               = json["amount"]                 as? String
            assetType            = json["asset_type"]             as? String
            assetCode            = json["asset_code"]             as? String
            assetIssuer          = json["asset_issuer"]           as? String
            sourceAssetCode      = json["source_asset_code"]      as? String
            sourceAssetIssuer    = json["source_asset_issuer"]    as? String
            sourceAssetType      = json["source_asset_type"]      as? String
            sourceMax            = json["source_max"]             as? String
            sourceAmount         = json["source_amount"]          as? String
            offerId              = json["offer_id"]               as? Int
            buyingAssetCode      = json["buying_asset_code"]      as? String
            buyingAssetIssuer    = json["buying_asset_issuer"]    as? String
            buyingAssetType      = json["buying_asset_type"]      as? String
            price                = json["price"]                  as? String
            //priceRate          = json["price_r"]                as? Types.PriceRate
            sellingAssetCode     = json["selling_asset_code"]     as? String
            sellingAssetIssuer   = json["selling_asset_issuer"]   as? String
            sellingAssetType     = json["selling_asset_type"]     as? String
            signerKey            = json["signer_key"]             as? String
            signerWeight         = json["signer_weight"]          as? Int
            masterKeyWeight      = json["master_keyweight"]       as? Int
            lowThreshold         = json["low_threshold"]          as? Int
            medThreshold         = json["med_threshold"]          as? Int
            highThreshold        = json["high_threshold"]         as? Int
            homeDomain           = json["home_domain"]            as? String
            setFlags             = json["set_flags"]              as? Array<Int>
            setFlagsStr          = json["set_flags_s"]            as? Array<String>
            clearFlags           = json["clear_flags"]            as? Array<Int>
            clearFlagsStr        = json["clear_flags_s"]          as? Array<String>
            trustee              = json["trustee"]                as? String
            trustor              = json["trustor"]                as? String
            limit                = json["limit"]                  as? String
            authorize            = json["authorize"]              as? Bool
            into                 = json["into"]                   as? String
            name                 = json["name"]                   as? String
            value                = json["value"]                  as? String
        }
        
    }
    
    public struct OperationLinks {
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
    
    
    // Data classes
/*
    public struct CreateAccountData: XDRCodable {
        public var destination     : String = ""
        public var startingBalance : Int64  = 0
        
        public init(xdrData: inout Data, count: Int32) {
            destination     = String(xdrData: &xdrData)
            startingBalance = Int64(xdrData: &xdrData)
        }
        
        public func toXDR(count: Int32) -> Data {
            let data = Data()
            //
            return data
        }
    }
*/
}

// END
