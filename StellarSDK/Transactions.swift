//
//  Transaction.swift
//  StellarSDK
//
//  Created by Laptop on 1/25/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Foundation

extension StellarSDK {

    open class TransactionsResponse {
        public var server    : Horizon?
        public var error     : ErrorMessage?
        public var raw       : String?
        //
        public var accountId : String = ""
        public var links     : Types.NavigationLinks?
        public var records   : [TransactionResponse] = []
        
        init() {}
        
        init(_ json: JsonType) {
            if  let list = json["_links"]    as? JsonType { links = Types.NavigationLinks(list) }
            if  let list = json["_embedded"] as? JsonType,
                let recs = list["records"]   as? JsonList {
                for item in recs {
                    if let temp = item as? JsonType { records.append(TransactionResponse(temp)) }
                }

            }
        }
    }
    
    open class TransactionResponse {
        public var links                 : TransactionLinks?
        public var id                    : String?
        public var pagingToken           : String?
        public var hash                  : String?
        public var ledger                : Int = 0
        public var createdAt             : String?
        public var sourceAccount         : String?
        public var sourceAccountSequence : String?
        public var feePaid               : Int = 0
        public var operationCount        : Int = 0
        public var envelopeXdr           : String?
        public var resultXdr             : String?
        public var resultMetaXdr         : String?
        public var feeMetaXdr            : String?
        public var memoType              : String?
        public var memo                  : String?
        public var signatures            : [String]?
        
        init(_ json: JsonType) {
            if let list = json["_links"] as? JsonType { links = TransactionLinks(list) }
            
            id                    = json["id"]                      as? String
            pagingToken           = json["paging_token"]            as? String
            hash                  = json["hash"]                    as? String
            ledger                = json["ledger"]                  as? Int ?? 0
            createdAt             = json["created_at"]              as? String
            sourceAccount         = json["source_account"]          as? String
            sourceAccountSequence = json["source_account_sequence"] as? String
            feePaid               = json["fee_paid"]                as? Int ?? 0
            operationCount        = json["operation_count"]         as? Int ?? 0
            envelopeXdr           = json["envelope_xdr"]            as? String
            resultXdr             = json["result_xdr"]              as? String
            resultMetaXdr         = json["result_meta_xdr"]         as? String
            feeMetaXdr            = json["fee_meta_xdr"]            as? String
            memoType              = json["memo_type"]               as? String
            memo                  = json["memo"]                    as? String
            signatures            = json["signatures"]              as? [String]
        }
    }
    
    public struct TransactionLinks {
        public var myself       : Types.Link?
        public var account      : Types.Link?
        public var ledger       : Types.Link?
        public var operations   : Types.Link?
        public var effects      : Types.Link?
        public var precedes     : Types.Link?
        public var succeeds     : Types.Link?
        
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
    
}

// END
