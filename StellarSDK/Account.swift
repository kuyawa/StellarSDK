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
    account.getData { value in ... }
    account.friendbot { result in ... }  // Only for testing accounts

Submit:
    account.createAccount(address, amount, memo) { result in ... }  // Creates new account and funds it
    account.setOptions(options) { result in ... }
    account.setAuthorization(flags) { result in ... }
    account.setInflation(address, memo) { result in ... }
    account.allowTrust(address, asset, authorize) { result in ... }
    account.changeTrust(asset, limit) { result in ... }
    account.merge(address) { result in ... }
    account.payment(address, amount, asset, memo) { result in ... }
    account.setHomeDomain(url) { result in ... }
    account.setData(key, value) { result in ... }
    more to come...

*/

import Foundation

extension StellarSDK {

    open class Account {
        open var network: Horizon.Network = .test
        open var server : Horizon?
        open var error  : ErrorMessage?
        
        var keyPair: KeyPair? = nil  // Crypto public/secret keys
        open var publicKey = ""      // Stellar public key
        open var secretKey = ""      // Stellar secret key
        open var sequence  = 0
        open var balance   = 0.0
        
        public init() { }
        
        // Read only account: If no secret provided, account can only fetch info
        public init(_ address: String, _ network: Horizon.Network?) {
            publicKey = address
            if let net = network { self.network = net }
        }
        
        public static func random() -> Account {
            let account       = Account()
            account.keyPair   = KeyPair.random()
            account.publicKey = account.keyPair!.stellarPublicKey
            account.secretKey = account.keyPair!.stellarSecretKey
            return account
        }
        
        public static func fromSecret(_ secret: String) -> Account? {
            if  let secret = secret.base32DecodedData {
                let bytes:[UInt8] = Array(secret)
                if let keyPair = KeyPair.fromSecret(bytes) {
                    let account = Account()
                    account.keyPair   = keyPair
                    account.publicKey = account.keyPair!.stellarPublicKey
                    account.secretKey = account.keyPair!.stellarSecretKey
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
        
        // Returns balance of any symbol as double
        public func getBalance(asset: String, callback: @escaping (_ balance: Double) -> Void) {
            let server = StellarSDK.Horizon(self.network)
            server.loadAccount(publicKey) { account in
                for balance in account.balances {
                    if balance.assetCode == asset {
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
        
        public func getAllData(callback: @escaping (_ data: [String: String]) -> Void) {
            let server = StellarSDK.Horizon(self.network)
            server.loadAccount(publicKey) { account in
                var dixy = account.data
                for (key, val) in dixy {
                    let data  = Data(base64Encoded: val) ?? Data()
                    let text  = String(data: data, encoding: .utf8) ?? ""
                    dixy[key] = text
                }
                callback(dixy)
            }
        }
        
        public func getSequence(callback: @escaping (_ seq: String?) -> Void) {
            let server = StellarSDK.Horizon(self.network)
            server.loadAccount(publicKey) { account in
                callback(account.sequence)
            }
        }
        
        // Self fund if testnet
        public func friendbot(callback: @escaping (_ ok: Bool) -> Void) {
            let server = StellarSDK.Horizon.test
            server.friendbot(address: publicKey) { response in
                let ok = !(response.error || response.status == 400)
                callback(ok)
            }
        }
        

        
        // ---- SUBMIT
        
        public func setAuthorization(_ flags: AccountAuthorizationFlags, callback: @escaping Callback) {
            guard self.keyPair != nil else {
                callback(StellarSDK.ErrorResponse(code: 500, message: "Account in read only mode, can't set options"))
                return
            }
            
            let source = KeyPair.getPublicKey(self.publicKey)!
            let secret = KeyPair.getSignerKey(self.secretKey)!
            
            let inner = SetOptionsOp(clearFlags: flags.off, setFlags: flags.on)
            let body  = OperationBody.SetOptions(inner)
            let op    = Operation(sourceAccount: source, body: body)
            
            let server = StellarSDK.Horizon(self.network)
            server.loadAccount(publicKey) { account in
                if account.error != nil {
                    print("Server Error")
                    callback(StellarSDK.ErrorResponse(code: account.error!.code, message: account.error!.text))
                    return
                }
                
                let builder = TransactionBuilder(source)
                builder.setSequence(account.sequence)
                builder.addOperation(op)
                builder.build()
                builder.sign(key: secret)

                server.submit(builder.txHash) { response in
                    if response.error {
                        print("Error submitting transaction to server")
                        print(response.raw)
                    }
                    callback(response)
                }
            }
        }

        public func setOptions(_ options: AccountOptions, callback: @escaping Callback) {
            guard self.keyPair != nil else {
                callback(StellarSDK.ErrorResponse(code: 500, message: "Account in read only mode, can't set options"))
                return
            }
            
            let source = KeyPair.getPublicKey(self.publicKey)!
            let secret = KeyPair.getSignerKey(self.secretKey)!
            
            var inner = SetOptionsOp()
            inner.inflationDest = options.inflationDest
            inner.clearFlags    = options.clearFlags
            inner.setFlags      = options.setFlags
            inner.masterWeight  = options.masterWeight
            inner.homeDomain    = options.homeDomain
            
            let body = OperationBody.SetOptions(inner)
            let op   = Operation(sourceAccount: source, body: body)
            
            let server = StellarSDK.Horizon(self.network)
            server.loadAccount(publicKey) { account in
                if account.error != nil {
                    print("Server Error")
                    callback(StellarSDK.ErrorResponse(code: account.error!.code, message: account.error!.text))
                    return
                }
                
                let builder = TransactionBuilder(source)
                builder.setSequence(account.sequence)
                builder.addOperation(op)
                builder.build()
                builder.sign(key: secret)

                server.submit(builder.txHash) { response in
                    if response.error {
                        print("Error submitting transaction to server")
                        print(response.raw)
                    }
                    callback(response)
                }
            }
        }
        
        public func setInflation(address: String, memo: String?, callback: @escaping Callback) {
            guard self.keyPair != nil else {
                callback(StellarSDK.ErrorResponse(code: 500, message: "Account in read only mode, can't set inflation"))
                return
            }
            
            let source  = KeyPair.getPublicKey(self.publicKey)!
            let secret  = KeyPair.getSignerKey(self.secretKey)!
            
            var destin: AccountID? = nil
            
            // Allow empty destin to reset inflation
            if !address.isEmpty { destin = KeyPair.getPublicKey(address) }

            let inner  = SetOptionsOp(inflationDest: destin)
            let body   = OperationBody.SetOptions(inner)
            let op     = Operation(sourceAccount: source, body: body)
            
            let server = StellarSDK.Horizon(self.network)
            server.loadAccount(publicKey) { account in
                if account.error != nil {
                    print("Server Error")
                    callback(StellarSDK.ErrorResponse(code: account.error!.code, message: account.error!.text))
                    return
                }
                
                let builder = TransactionBuilder(source)
                builder.setSequence(account.sequence)
                builder.addOperation(op)
                builder.addMemoText(memo)
                builder.build()
                builder.sign(key: secret)

                server.submit(builder.txHash) { response in
                    if response.error {
                        print("Error submitting transaction to server")
                        print(response.raw)
                    }
                    callback(response)
                }
            }
        }
        
        public func allowTrust(address: String, asset: Asset, authorize: Bool, callback: @escaping Callback) {
            guard self.keyPair != nil else {
                callback(StellarSDK.ErrorResponse(code: 500, message: "Account in read only mode, can't allow trust"))
                return
            }
            
            let source  = KeyPair.getPublicKey(self.publicKey)!
            let secret  = KeyPair.getSignerKey(self.secretKey)!
            
            guard let trustor = KeyPair.getPublicKey(address) else {
                callback(StellarSDK.ErrorResponse(code: 500, message: "Invalid address to trust"))
                return
            }
            
            let inner  = AllowTrustOp(trustor: trustor, authorize: authorize)
            let body   = OperationBody.AllowTrust(inner)
            let op     = Operation(sourceAccount: source, body: body)
            
            let server = StellarSDK.Horizon(self.network)
            server.loadAccount(publicKey) { account in
                if account.error != nil {
                    print("Server Error")
                    callback(StellarSDK.ErrorResponse(code: account.error!.code, message: account.error!.text))
                    return
                }
                
                let builder = TransactionBuilder(source)
                builder.setSequence(account.sequence)
                builder.addOperation(op)
                builder.build()
                builder.sign(key: secret)

                server.submit(builder.txHash) { response in
                    if response.error {
                        print("Error submitting transaction to server")
                        print(response.raw)
                    }
                    callback(response)
                }
            }
        }

        public func changeTrust(asset: Asset, limit: Int64 = Int64.max, callback: @escaping Callback) {
            guard self.keyPair != nil else {
                callback(StellarSDK.ErrorResponse(code: 500, message: "Account in read only mode, can't change trust"))
                return
            }
            
            let source = KeyPair.getPublicKey(self.publicKey)!
            let secret = KeyPair.getSignerKey(self.secretKey)!
            
            let inner  = ChangeTrustOp(line: asset, limit: limit)
            let body   = OperationBody.ChangeTrust(inner)
            let op     = Operation(sourceAccount: source, body: body)
            
            let server = StellarSDK.Horizon(self.network)
            server.loadAccount(publicKey) { account in
                if account.error != nil {
                    print("Server Error")
                    callback(StellarSDK.ErrorResponse(code: account.error!.code, message: account.error!.text))
                    return
                }
                
                let builder = TransactionBuilder(source)
                builder.setSequence(account.sequence)
                builder.addOperation(op)
                builder.build()
                builder.sign(key: secret)

                server.submit(builder.txHash) { response in
                    if response.error {
                        print("Error submitting transaction to server")
                        print(response.raw)
                    }
                    callback(response)
                }
            }
        }
        
        public func merge(address: String, callback: @escaping Callback) {
            guard self.keyPair != nil else {
                callback(StellarSDK.ErrorResponse(code: 500, message: "Account in read only mode, can't be merged"))
                return
            }
            
            let source  = KeyPair.getPublicKey(self.publicKey)!
            let secret  = KeyPair.getSignerKey(self.secretKey)!
            
            guard let destin = KeyPair.getPublicKey(address) else {
                callback(StellarSDK.ErrorResponse(code: 500, message: "Invalid address to be merged"))
                return
            }

            let body   = OperationBody.AccountMerge(destin)
            let op     = Operation(sourceAccount: source, body: body)
            
            let server = StellarSDK.Horizon(self.network)
            server.loadAccount(publicKey) { account in
                if account.error != nil {
                    print("Server Error")
                    callback(StellarSDK.ErrorResponse(code: account.error!.code, message: account.error!.text))
                    return
                }
                
                let builder = TransactionBuilder(source)
                builder.setSequence(account.sequence)
                builder.addOperation(op)
                builder.build()
                builder.sign(key: secret)

                server.submit(builder.txHash) { response in
                    if response.error {
                        print("Error submitting transaction to server")
                        print(response.raw)
                    }
                    callback(response)
                }
            }
        }
        
        public func createAccount(address: String, amount: Int64, memo: String?, callback: @escaping Callback) {
            guard self.keyPair != nil else {
                callback(StellarSDK.ErrorResponse(code: 500, message: "Account in read only mode, can't fund"))
                return
            }

            let source = KeyPair.getPublicKey(self.publicKey)!
            let secret = KeyPair.getSignerKey(self.secretKey)!

            guard let destin = KeyPair.getPublicKey(address) else {
                callback(StellarSDK.ErrorResponse(code: 500, message: "Invalid address to be funded"))
                return
            }
            
            let inner  = CreateAccountOp(destination: destin, startingBalance: amount * 10000000) // Seven decimals
            let body   = OperationBody.CreateAccount(inner)
            let op     = Operation(sourceAccount: source, body: body)
            
            let server = StellarSDK.Horizon(self.network)
            server.loadAccount(publicKey) { account in
                if account.error != nil {
                    print("Server Error")
                    callback(StellarSDK.ErrorResponse(code: account.error!.code, message: account.error!.text))
                    return
                }
                
                //let builder = TransactionBuilder(source, sequence, operation, memo) // Quick builder
                let builder = TransactionBuilder(source)
                builder.setSequence(account.sequence)
                builder.addOperation(op)
                builder.addMemoText(memo)
                builder.build()
                builder.sign(key: secret) // sec64

                server.submit(builder.txHash) { response in
                    if response.error {
                        print("Error submitting transaction to server")
                        print(response.raw)
                    }
                    callback(response)
                }
            }
        }
        
        public func payment(address: String, amount: Float, asset: Asset? = Asset.Native, memo: String?, callback: @escaping Callback) {
            guard self.keyPair != nil else {
                callback(StellarSDK.ErrorResponse(code: 500, message: "Account in read only mode, can't pay"))
                return
            }

            let source = KeyPair.getPublicKey(self.publicKey)!
            let secret = KeyPair.getSignerKey(self.secretKey)!
            
            guard let destin = KeyPair.getPublicKey(address) else {
                callback(StellarSDK.ErrorResponse(code: 500, message: "Invalid address to send payment"))
                return
            }
            
            let asset  = asset ?? Asset.Native
            let inner  = PaymentOp(destination: destin, asset: asset, amount: Int64(amount * 10000000.0)) // Seven decimals
            let body   = OperationBody.Payment(inner)
            let op     = Operation(sourceAccount: source, body: body)
            
            let server = StellarSDK.Horizon(self.network)
            server.loadAccount(publicKey) { account in
                if account.error != nil {
                    print("Server Error")
                    callback(StellarSDK.ErrorResponse(code: account.error!.code, message: account.error!.text))
                    return
                }
                
                let builder = TransactionBuilder(source)
                builder.setSequence(account.sequence)
                builder.addOperation(op)
                builder.addMemoText(memo)
                builder.build()
                builder.sign(key: secret)

                server.submit(builder.txHash) { response in
                    if response.error {
                        print("Error submitting payment to server")
                        print(response.raw)
                    }
                    callback(response)
                }
            }
        }
        
        public func setHomeDomain(_ url: String, callback: @escaping Callback) {
            var options = AccountOptions()
            options.homeDomain = url
            setOptions(options, callback: callback)
        }
        
        public func setData(_ key: String, _ value: String?, callback: @escaping Callback) {
            guard self.keyPair != nil else {
                callback(StellarSDK.ErrorResponse(code: 500, message: "Account in read only mode, can't set options"))
                return
            }
            
            guard !key.isEmpty else {
                callback(StellarSDK.ErrorResponse(code: 500, message: "Data key is required"))
                return
            }
            
            let source = KeyPair.getPublicKey(self.publicKey)!
            let secret = KeyPair.getSignerKey(self.secretKey)!
            
            var text:String? = value
            if let value = value, value.isEmpty { text = nil } // If empty, make null to remove
            
            let inner = ManageDataOp(dataName: key, dataValue: text)
            let body  = OperationBody.ManageData(inner)
            let op    = Operation(sourceAccount: source, body: body)
            
            let server = StellarSDK.Horizon(self.network)
            server.loadAccount(publicKey) { account in
                if account.error != nil {
                    print("Server Error")
                    callback(StellarSDK.ErrorResponse(code: account.error!.code, message: account.error!.text))
                    return
                }
                
                let builder = TransactionBuilder(source)
                builder.setSequence(account.sequence)
                builder.addOperation(op)
                builder.build()
                builder.sign(key: secret)

                server.submit(builder.txHash) { response in
                    if response.error {
                        print("Error submitting transaction to server")
                        print(response.raw)
                    }
                    callback(response)
                }
            }
        }
        
        // TODO:
        public func manageOffer() {}
        public func createPassiveOffer() {}
        public func setSigner() {}
        
    } // Account
    
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
            server?.loadAccountTransactions(address: accountId!, options: options, callback: callback)
        }
        
        open func payments(){}
        open func details(){}
        open func operations(){}
        open func effects(){}
        open func offers(){}
        open func accountData(){}
        
        func getSequence() -> SequenceNumber {
            guard let seq = sequence, !seq.isEmpty, let num = UInt64(seq) else { return 0 }
            return num
        }
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
        public var inflationDest : AccountID? = nil   // sets the inflation destination
        public var clearFlags    : UInt32? = nil      // which flags to clear
        public var setFlags      : UInt32? = nil      // which flags to set
        public var masterWeight  : UInt32? = nil      // weight of the master account
        public var lowThreshold  : UInt32? = nil
        public var medThreshold  : UInt32? = nil
        public var highThreshold : UInt32? = nil
        public var homeDomain    : String? = nil      // sets the home domain
        public var signer        : Signer? = nil      // Add, update or remove a signer for the account. Signer is deleted if the weight is 0
        
        public init() {}
    }
    
    public struct AccountAuthorizationFlags {
        public var required  : Bool = false
        public var revocable : Bool = false
        public var immutable : Bool = false
    
        public var on: UInt32 {
            return UInt32( (required ? 0x1 : 0x0)  | (revocable ? 0x2 : 0x0) | (immutable ? 0x4 : 0x0) )
        }
        
        public var off: UInt32 {
            return UInt32( (required ? 0x0 : 0x1)  | (revocable ? 0x0 : 0x2) | (immutable ? 0x0 : 0x4) )
        }
        
        public init() {}
        
        public init(required: Bool, revocable: Bool, immutable: Bool) {
            self.required  = required
            self.revocable = revocable
            self.immutable = immutable
        }
    }
}

// END
