//
//  Account.swift
//  StellarSDK
//
//  Created by Laptop on 1/25/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

/*
 
Operational:
    var account = Account.random()
    var account = Account.fromSecret(secret)
    var account = Account('GA1234...')
 
    account.useNetwork(.test)
    account.useTestNetwork()
    account.usePublicNetwork()

 Requests:
    account.getInfo { info in ... }
    account.getBalance { balance in ... }  // Native
    account.getBalance("EUR") { balance in ... }
    account.getBalances { balances in ... } // All
    account.getPayments { payments in ...}
    account.getPayments(limit: 50, order: .desc) { payments in ...}
    account.getOperations { operations in ...}
    account.getTransactions { tranx in ... }
    account.getTransactions(cursor: "123456", limit: 20, order: .asc) { tranx in ... }
    account.getEffects { effects in ... }
    account.getOffers { offers in ... }
    account.getSequence { sequence in ... }
    account.friendbot { result in ... }  // Only for testing accounts

Submit:
    account.setOptions(options) { result in ... }
    account.setInflation(address, memo) { result in ... }
    account.fund(address, amount, memo) { result in ... }  // Creates new account and funds it
    account.send(address, amount, asset, memo) { result in ... }
    more to come...

*/

import Foundation

extension StellarSDK {

    open class Account {
        open var network: Horizon.Network = .test
        open var server : Horizon?
        open var error  : ErrorMessage?
        
        open var publicKey = ""
        open var secretKey = ""
        open var sequence  = 0
        open var balance   = 0.0
        
        public init() {}
        
        public init(_ address: String, _ network: Horizon.Network?) {
            publicKey = address
            if let net = network { self.network = net }
        }
        
        static func random() -> Account {
            let keyPair = KeyPair.random()
            let account = Account()
            account.publicKey = keyPair.publicKey.base32
            account.secretKey = keyPair.secretKey.base32
            return account
        }
        
        static func fromSecret(_ secret: String) -> Account? {
            if  let secret = secret.base32DecodedData {
                let bytes:[UInt8] = Array(secret)
                if let keyPair = KeyPair.fromSecret(bytes) {
                    let account = Account()
                    account.publicKey = keyPair.publicKey.base32
                    account.secretKey = keyPair.secretKey.base32
                    return account
                }
            }
            return nil
        }

        public func useNetwork(_ net: Horizon.Network) {
            network = net
        }
        
        public func usePublicNetwork() {
            network = .live
        }
        
        public func useTestNetwork() {
            network = .test
        }
        
        
        // ---- REQUEST
        
        public func getInfo(callback: @escaping (_ account: AccountResponse) -> Void) {
            let server = StellarSDK.Horizon(self.network)
            server.loadAccount(publicKey) { account in
                callback(account)
            }
        }
        
        // Returns balance of native asset as double
        public func getBalance(callback: @escaping (_ balance: Double) -> Void) {
            let server = StellarSDK.Horizon(self.network)
            server.loadAccount(publicKey) { account in
                for balance in account.balances {
                    if balance.assetType == "native" {
                        callback(Double(balance.balance) ?? -1)
                        return
                    }
                }
                callback(-1)
            }
        }
        
        // Returns balance of any asset as double
        public func getBalance(asset: String, callback: @escaping (_ balance: Double) -> Void) {
            let server = StellarSDK.Horizon(self.network)
            server.loadAccount(publicKey) { account in
                for balance in account.balances {
                    if balance.assetType == asset {
                        callback(Double(balance.balance) ?? -1)
                        return
                    }
                }
                callback(-1)
            }
        }
        
        // Return balances of all assets
        public func getBalances(callback: @escaping (_ balances: [Types.Balance]) -> Void) {
            let server = StellarSDK.Horizon(self.network)
            server.loadAccount(publicKey) { account in
                callback(account.balances)
            }
        }
        
        public func getPayments(cursor: String? = "", limit: Int? = 10, order: SortOrder? = .desc, callback: @escaping (_ payments: PaymentsResponse) -> Void) {
            let options = ListOptions(cursor: cursor ?? "", limit: limit ?? 10, order: order ?? .desc)
            let server = StellarSDK.Horizon(self.network)
            server.loadAccountPayments(address: publicKey, options: options) { payments in
                callback(payments)
            }
        }
        
        public func getOperations(cursor: String? = "", limit: Int? = 10, order: SortOrder? = .desc, callback: @escaping (_ operations: OperationsResponse) -> Void) {
            let options = ListOptions(cursor: cursor ?? "", limit: limit ?? 10, order: order ?? .desc)
            let server = StellarSDK.Horizon(self.network)
            server.loadAccountOperations(address: publicKey, options: options) { operations in
                callback(operations)
            }
        }
        
        public func getTransactions(cursor: String? = "", limit: Int? = 10, order: SortOrder? = .desc, callback: @escaping (_ transactions: TransactionsResponse) -> Void) {
            let options = ListOptions(cursor: cursor ?? "", limit: limit ?? 10, order: order ?? .desc)
            let server = StellarSDK.Horizon(self.network)
            server.loadAccountTransactions(address: publicKey, options: options) { transactions in
                callback(transactions)
            }
        }
        
        public func getEffects(cursor: String? = "", limit: Int? = 10, order: SortOrder? = .desc, callback: @escaping (_ effects: EffectsResponse) -> Void) {
            let options = ListOptions(cursor: cursor ?? "", limit: limit ?? 10, order: order ?? .desc)
            let server = StellarSDK.Horizon(self.network)
            server.loadAccountEffects(address: publicKey, options: options) { effects in
                callback(effects)
            }
        }
        
        public func getOffers(cursor: String? = "", limit: Int? = 10, order: SortOrder? = .desc, callback: @escaping (_ effects: OffersResponse) -> Void) {
            let options = ListOptions(cursor: cursor ?? "", limit: limit ?? 10, order: order ?? .desc)
            let server = StellarSDK.Horizon(self.network)
            server.loadAccountOffers(address: publicKey, options: options) { offers in
                callback(offers)
            }
        }
        
        public func getData(key: String, callback: @escaping (_ value: String) -> Void) {
            let server = StellarSDK.Horizon(self.network)
            server.loadAccountData(address: publicKey, key: key) { value in
                callback(value)
            }
        }
        
        public func getAllData(callback: @escaping Callback) {
            // TODO:
        }
        
        public func getSequence(callback: @escaping Callback) {
            // TODO:
        }
        
        public func friendbot(callback: @escaping Callback) {
            let server = StellarSDK.Horizon.test
            server.friendbot(address: publicKey) { response in
                callback(response) // TODO: Return true or false
            }
        }
        

        
        // ---- SUBMIT 
        
        public func setOptions(options: AccountOptions, callback: @escaping Callback) {
            // TODO:
        }

        public func setInflation(address: String, memo: String?, callback: @escaping Callback) {
            // TODO:
        }
        
        public func fund(address: String, amount: Double, memo: String?, callback: @escaping Callback) {
            // TODO:
        }
        
        public func send(address: String, amount: Double, asset: String? = "native", memo: String?, callback: @escaping Callback) {
            // TODO:
        }
        
    }
    
    open class AccountResponse {
        // Operational
        open var server        : Horizon?
        open var error         : ErrorMessage?
        open var raw           : String?
        // Informational
        open var links         : AccountLinks?
        open var id            : String?
        open var accountId     : String?
        open var pagingToken   : String?
        open var sequence      : String?
        open var subentryCount : Int = 0
        open var thresholds    : Types.Thresholds?
        open var flags         : Types.Flags?
        open var balances      : [Types.Balance] = []
        open var signers       : [Types.Signer]  = []
        open var data          : [String:String] = [:]
        
        public init() {
            // Empty account
        }
        
        public init(_ json: JsonType) {
            if let temp = json["_links"] as? JsonType { links = AccountLinks(temp) }
            id = json["id"] as? String
            pagingToken   = json["paging_token"]   as? String
            accountId     = json["account_id"]     as? String
            sequence      = json["sequence"]       as? String
            subentryCount = json["subentry_count"] as? Int ?? 0
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
            server?.loadAccountTransactions(address: accountId!, options: options, callback: callback)
        }
        
        open func payments(){}
        open func details(){}
        open func operations(){}
        open func effects(){}
        open func offers(){}
        open func accountData(){}
    }
    
    public struct AccountLinks {
        public var myself       : Types.Link?
        public var transactions : Types.Link?
        public var operations   : Types.Link?
        public var payments     : Types.Link?
        public var effects      : Types.Link?
        public var offers       : Types.Link?
        public var trades       : Types.Link?
        public var data         : Types.Link?
        
        public init(_ json: JsonType) {
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

    public struct AccountOptions {
        public var authRequired    : Bool?
        public var authRevocable   : Bool?
        public var authImmutable   : Bool?
        public var inflationDestin : String?
    }
}

// END
