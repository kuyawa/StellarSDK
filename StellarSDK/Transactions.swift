//
//  Transaction.swift
//  StellarSDK
//
//  Created by Laptop on 1/25/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Foundation

extension StellarSDK {

    public class Transaction {
        var id       = ""
        var hash     = ""
        var envelope = ""
        
        init(_ account: Account) {
            //
        }
        
        func addOperation(_ operation: Operation) {
            //
        }
        
        func addMemo(_ text: String) {
            //
        }
        
        func build() {
            //
        }
        
        func sign(_ account: Account) {
            //
        }
        
        func submit() {
            //
        }
    }
    
    public class TransactionsResponse {
        var _server   : Horizon?
        var error     : ErrorMessage?
        var accountId : String = ""
        var links     : Types.NavigationLinks?
        var records   : [TransactionResponse] = []
        
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
    
    public class TransactionResponse {
        var links                 : Types.TransactionLinks?
        var id                    : String?
        var pagingToken           : String?
        var hash                  : String?
        var ledger                : Int = 0
        var createdAt             : String?
        var sourceAccount         : String?
        var sourceAccountSequence : String?
        var feePaid               : Int = 0
        var operationCount        : Int = 0
        var envelopeXdr           : String?
        var resultXdr             : String?
        var resultMetaXdr         : String?
        var feeMetaXdr            : String?
        var memoType              : String?
        var memo                  : String?
        var signatures            : [String]?
        
        init(_ json: JsonType) {
            if let list = json["_links"] as? JsonType { links = Types.TransactionLinks(list) }
            id                    = json["id"] as? String
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
}

// END
