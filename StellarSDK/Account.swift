//
//  Account.swift
//  StellarSDK
//
//  Created by Laptop on 1/25/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Foundation

extension StellarSDK {

    open class Account {
        var publicKey = ""
        var secretKey = ""
        var sequence  = 0
        var balance   = 0.0
        
        func load() {
            //
        }
        
        func getBalance(_ callback: @escaping Callback) {
            //
        }
        
        func getSequence(_ callback: @escaping Callback) {
            //
        }
        
        // var act = Account.random()
        // var act = Account.fromSecret(secret)
        // act.fundTest()
        // act.fund(source, amount)
        // act.getBalance()
        // act.getSequence()
        // act.nextSequence()
        static func random() {
            //
        }
        
        static func fromSecret(_ secret: String) {
            //
        }
    }
    
    open class AccountResponse {
        var _server       : Horizon?
        var error         : ErrorMessage?
        var links         : Types.AccountLinks?
        var id            : String?
        var accountId     : String?
        var pagingToken   : String?
        var sequence      : String?
        var subentryCount : Int = 0
        var thresholds    : Types.Thresholds?
        var flags         : Types.Flags?
        var balances      : [Types.Balance] = []
        var signers       : [Types.Signer]  = []
        var data          : [String:String] = [:]
        
        init() {
            // Empty account
        }
        
        init(_ json: JsonType) {
            if let temp = json["_links"] as? JsonType { links = Types.AccountLinks(temp) }
            id = json["id"] as? String
            pagingToken   = json["paging_token"]   as? String
            accountId     = json["account_id"]     as? String
            sequence      = json["sequence"]       as? String
            subentryCount = json["subentry_count"] as! Int
            if let temp   = json["thresholds"]     as? JsonType { thresholds = Types.Thresholds(temp) }
            if let temp   = json["flags"]          as? JsonType { flags      = Types.Flags(temp) }
            if let list   = json["balances"]       as? JsonList {
                for item in list {
                    if let temp = item as? JsonType { balances.append(Types.Balance(temp)) }
                }
            }
            if let list = json["signers"] as? JsonList {
                for item in list {
                    if let temp = item as? JsonType { signers.append(Types.Signer(temp)) }
                }
            }
            if let temp = json["data"] as? [String:String] { data = temp }
        }
        
        func transactions(options: ListOptions?, _ callback: @escaping (_ transactions: TransactionsResponse) -> Void) {
            print("Calling server for tranxs")
            _server?.loadAccountTransactions(address: accountId!, options: options, callback: callback)
        }
        
        func details(){}
        func accountData(){}
        func operations(){}
        func payments(){}
        func effects(){}
        func offers(){}
    }
}

// END
