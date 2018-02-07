//
//  Horizon.swift
//  StellarSDK
//
//  Created by Laptop on 1/24/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Foundation

public struct Response {
    public var status  = 200
    public var error   = false
    public var message = ""
    public var raw     = ""
    public var headers = [String:String]()
    public var body    = ""
    public var xdr     = ""
    public var text    = ""
    public var json    = [String:Any]()
    public var list    = [Any]()
}

enum HorizonErrors {
    case connectionError
    case serverError
    case insufficientParameters
    case invalidParameters
    case invalidResponse
}

extension StellarSDK {
    
    open class Horizon {
        
        public enum Network { case test, live }
        
        public enum NetworkId: String {
            case test = "Test SDF Network ; September 2015"
            case live = "Public Global Stellar Network ; September 2015"
        }
        
        let HORIZON_LIVE = "https://horizon.stellar.org"
        let HORIZON_TEST = "https://horizon-testnet.stellar.org"
        
        public static var live: Horizon { return Horizon(.live) }
        public static var test: Horizon { return Horizon(.test) }
        
        var serverUrl = ""
        
        init(_ horizon: Network){
            if horizon == .live {
                serverUrl = HORIZON_LIVE
            } else {
                serverUrl = HORIZON_TEST
            }
        }
        
        
        // HTTP Request
        
        private class Request {
            
            
            //---- Public methods
            
            static func get(_ uri: String, _ params: Parameters?, _ callback: @escaping Callback) {
                guard let url = URL(string: uri) else {
                    callback(errorResponse(code: 500, text: "Invalid url"))
                    return
                }

                var request = URLRequest(url: url)
                if let params = params { request = Request.URLBuild(uri, params) }
                print("GET", request.url!)
                
                URLSession.shared.dataTask(with: request) { data, response, error in
                    let result = self.handleResponse(data, response, error)
                    callback(result)
                }.resume()
            }
            
            static func post(_ uri: String, _ params: Parameters, _ callback: @escaping Callback) {
                guard let url = URL(string: uri) else {
                    callback(errorResponse(code: 500, text: "Invalid url"))
                    return
                }
                
                var request   = URLRequest(url: url)
                let txEncoded = Request.URLEncode(params)
                let httpBody  = txEncoded.dataUTF8
                request.httpMethod = "POST"
                request.httpBody   = httpBody
                
                print("POST", request.url!)
                print("PARAMS", txEncoded)

                URLSession.shared.dataTask(with: request) { data, response, error in
                    let result = self.handleResponse(data, response, error)
                    callback(result)
                }.resume()
            }
            
            
            // Builds query from parameters for urls
            static private func URLQuery(_ params: Parameters?) -> [URLQueryItem] {
                var query = [URLQueryItem]()
                if let params = params {
                    for (key, val) in params {
                        if let value = val {
                            query.append(URLQueryItem(name: key, value: "\(value)"))
                        }
                    }
                }
                
                return query
            }
            
            // Returns url+query as URL for GET requests
            static private func URLEncode(_ uri: String, _ params: Parameters?) -> URL {
                let query = URLQuery(params)
                var components = URLComponents(string: uri)!
                components.queryItems = query
                
                return components.url!
            }
            
            // Returns query as String for POST requests
            static private func URLEncode(_ params: Parameters?) -> String {
                let query = URLQuery(params)
                var components = URLComponents()
                components.queryItems = query

                return components.query!
            }
            
            static private func URLBuild(_ uri: String, _ params: Parameters?) -> URLRequest {
                //let agent   = "Stellar Bot 1.0"
                let encoded = URLEncode(uri, params)
                let request = URLRequest(url: encoded)
                //request.setValue(agent, forHTTPHeaderField: "User-Agent")
                return request
            }
            
            static private func handleResponse(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Response {
                var result = Response()
                
                guard error == nil else {
                    print("API ERROR: ", error!.localizedDescription)
                    result.error = true
                    result.message = error!.localizedDescription
                    return result
                }
                
                if let data = data, let text = String(data: data, encoding: .utf8) {
                    print("API RESPONSE")
                    result.raw  = text
                    //result.text = text
                    // Accept both objects or arrays, arrays will be assigned to result.list
                    let json = try? JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                    if let dixy = json as? [String:Any] {
                        result.json = dixy
                        //print(dixy)
                    } else if let list = json as? [Any] {
                        result.list = list
                        //print(list)
                    }
                }
                
                return result
            }

            static private func errorResponse(code: Int, text: String) -> Response {
                print("API ERROR: ", text)
                
                var result = Response()
                result.error   = true
                result.status  = code
                result.message = text
                
                return result
            }
            
        }
        
        
        
        //---- SDK methods
        
        public func loadAccount(_ address: String, _ callback: @escaping (_ account: AccountResponse) -> Void) {
            let url = serverUrl + "/accounts/" + address
            Request.get(url, nil) { response in
                // If response.error
                if response.error {
                    print("Server error")
                    //throw "Account not found"
                    let account = AccountResponse()
                    account.server = self
                    account.error  = ErrorMessage(code: 500, text: "Server error")
                    account.raw    = response.raw
                    callback(account)
                }
                if let status = response.json["status"] as? Int, status == 404 {
                    print("Account not found")
                    let account = AccountResponse()
                    account.server = self
                    account.error  = ErrorMessage(code: 404, text: "Account not found")
                    account.raw    = response.raw
                    callback(account)
                } else {
                    let account = AccountResponse(response.json)
                    account.server = self
                    account.error  = nil
                    account.raw    = response.raw
                    callback(account)
                }
            }
        }
        
        public func loadAccountOperations(address: String, options: ListOptions?, callback: @escaping (_ operations: OperationsResponse) -> Void) {
            let url = serverUrl + "/accounts/" + address + "/operations/"
            var params: Parameters? = nil
            if let options = options {
                params = Parameters()
                if !options.cursor.isEmpty { params!["cursor"] = options.cursor }
                if options.limit > 0       { params!["limit"]  = options.limit }
                if options.order == .desc  { params!["order"]  = "desc" }
            }
            Request.get(url, params) { response in
                if let status = response.json["status"] as? Int, status == 404 {
                    print("Account not found")
                    let operations = OperationsResponse()
                    operations.server = self
                    operations.error  = ErrorMessage(code: 404, text: "Account not found")
                    operations.raw    = response.raw
                    callback(operations)
                } else {
                    let operations = OperationsResponse(response.json)
                    operations.server = self
                    operations.error  = nil
                    operations.raw    = response.raw
                    callback(operations)
                }
            }
        }
        
        public func loadAccountPayments(address: String, options: ListOptions?, callback: @escaping (_ payments: PaymentsResponse) -> Void) {
            let url = serverUrl + "/accounts/" + address + "/payments/"
            var params: Parameters? = nil
            if let options = options {
                params = Parameters()
                if !options.cursor.isEmpty { params!["cursor"] = options.cursor }
                if options.limit > 0       { params!["limit"]  = options.limit }
                if options.order == .desc  { params!["order"]  = "desc" }
            }
            Request.get(url, params) { response in
                if let status = response.json["status"] as? Int, status == 404 {
                    print("Account not found")
                    let payments = PaymentsResponse()
                    payments.server = self
                    payments.error  = ErrorMessage(code: 404, text: "Account not found")
                    payments.raw    = response.raw
                    callback(payments)
                } else {
                    let payments = PaymentsResponse(response.json)
                    payments.server = self
                    payments.error  = nil
                    payments.raw    = response.raw
                    callback(payments)
                }
            }
        }
        
        public func loadAccountTransactions(address: String, options: ListOptions?, callback: @escaping (_ transactions: TransactionsResponse) -> Void) {
            let url = serverUrl + "/accounts/" + address + "/transactions/"
            var params: Parameters? = nil
            if let options = options {
                params = Parameters()
                if !options.cursor.isEmpty { params!["cursor"] = options.cursor }
                if options.limit > 0       { params!["limit"]  = options.limit }
                if options.order == .desc  { params!["order"]  = "desc" }
            }
            Request.get(url, params) { response in
                if let status = response.json["status"] as? Int, status == 404 {
                    print("Account not found")
                    let transactions = TransactionsResponse()
                    transactions.server = self
                    transactions.error  = ErrorMessage(code: 404, text: "Account not found")
                    transactions.raw    = response.raw
                    callback(transactions)
                } else {
                    let transactions = TransactionsResponse(response.json)
                    transactions.server = self
                    transactions.error  = nil
                    transactions.raw    = response.raw
                    callback(transactions)
                }
            }
        }

        public func loadAccountEffects(address: String, options: ListOptions?, callback: @escaping (_ effects: EffectsResponse) -> Void) {
            let url = serverUrl + "/accounts/" + address + "/effects/"
            var params: Parameters? = nil
            if let options = options {
                params = Parameters()
                if !options.cursor.isEmpty { params!["cursor"] = options.cursor }
                if options.limit > 0       { params!["limit"]  = options.limit }
                if options.order == .desc  { params!["order"]  = "desc" }
            }
            Request.get(url, params) { response in
                if let status = response.json["status"] as? Int, status == 404 {
                    print("Account not found")
                    let effects = EffectsResponse()
                    effects.server = self
                    effects.error  = ErrorMessage(code: 404, text: "Account not found")
                    effects.raw    = response.raw
                    callback(effects)
                } else {
                    let effects = EffectsResponse(response.json)
                    effects.server = self
                    effects.error  = nil
                    effects.raw    = response.raw
                    callback(effects)
                }
            }
        }
        
        public func loadAccountOffers(address: String, options: ListOptions?, callback: @escaping (_ effects: OffersResponse) -> Void) {
            let url = serverUrl + "/accounts/" + address + "/offers/"
            var params: Parameters? = nil
            if let options = options {
                params = Parameters()
                if !options.cursor.isEmpty { params!["cursor"] = options.cursor }
                if options.limit > 0       { params!["limit"]  = options.limit }
                if options.order == .desc  { params!["order"]  = "desc" }
            }
            Request.get(url, params) { response in
                if let status = response.json["status"] as? Int, status == 404 {
                    print("Account not found")
                    let offers = OffersResponse()
                    offers.server = self
                    offers.error  = ErrorMessage(code: 404, text: "Account not found")
                    offers.raw    = response.raw
                    callback(offers)
                } else {
                    let offers = OffersResponse(response.json)
                    offers.server = self
                    offers.error  = nil
                    offers.raw    = response.raw
                    callback(offers)
                }
            }
        }
    
        public func loadAccountData(address: String, key: String, callback: @escaping (_ value: String) -> Void) {
            let url = serverUrl + "/accounts/" + address + "/data/"+key
            Request.get(url, nil) { response in
                if let status = response.json["status"] as? Int, status == 404 {
                    print("Account not found")
                    callback("")
                } else {
                    var value = ""
                    if let str  = response.json["value"] as? String,
                       let data = Data(base64Encoded: str) {
                          value = String(data: data, encoding: .utf8)!
                    }
                    callback(value)
                }
            }
        }
        
        //func submitTransaction(_ tranx: StellarSDK.Transaction, _ callback: @escaping Callback) {
        //  TODO:
        //}

        
        
        //---- API Methods
        
        public func account(address: String, _ callback: @escaping Callback) {
            let url = serverUrl + "/accounts/" + address
            Request.get(url, nil, callback)
        }
        
        public func accounts(data: Parameters?, _ callback: @escaping Callback) {
            let url = serverUrl + "/accounts/"
            Request.get(url, data, callback)
        }
        
        public func accountEffects(address: String, data: Parameters?, _ callback: @escaping Callback) {
            let url = serverUrl + "/accounts/" + address + "/effects/"
            Request.get(url, data, callback)
        }
        
        public func accountOffers(address: String, data: Parameters?, _ callback: @escaping Callback) {
            let url = serverUrl + "/accounts/" + address + "/offers/"
            Request.get(url, data, callback)
        }
        
        public func accountOperations(address: String, data: Parameters?, _ callback: @escaping Callback) {
            let url = serverUrl + "/accounts/" + address + "/operations/"
            Request.get(url, data, callback)
        }
        
        public func accountPayments(address: String, data: Parameters?, _ callback: @escaping Callback) {
            let url = serverUrl + "/accounts/" + address + "/payments/"
            Request.get(url, data, callback)
        }
        
        public func accountTransactions(address: String, data: Parameters?, _ callback: @escaping Callback) {
            let url = serverUrl + "/accounts/" + address + "/transactions/"
            Request.get(url, data, callback)
        }
        
        public func transaction(hash: String, _ callback: @escaping Callback) {
            let url = serverUrl + "/transactions/" + hash
            Request.get(url, nil, callback)
        }
        
        public func transactions(data: Parameters?, _ callback: @escaping Callback) {
            let url = serverUrl + "/transactions/"
            Request.get(url, data, callback)
        }
        
        public func transactionOperations(hash: String, data: Parameters?, _ callback: @escaping Callback) {
            let url = serverUrl + "/transactions/" + hash + "/operations/"
            Request.get(url, data, callback)
        }
        
        public func transactionEffects(hash: String, data: Parameters?, _ callback: @escaping Callback) {
            let url = serverUrl + "/transactions/" + hash + "/effects/"
            Request.get(url, data, callback)
        }
        
        public func transactionPayments(hash: String, data: Parameters?, _ callback: @escaping Callback) {
            let url = serverUrl + "/transactions/" + hash + "/payments/"
            Request.get(url, data, callback)
        }
        
        public func orderbook(data: Parameters?, _ callback: @escaping Callback) {
            let url = serverUrl + "/order_book/"
            Request.get(url, data, callback)
        }
        
        public func orderbookTrades(data: Parameters?, _ callback: @escaping Callback) {
            let url = serverUrl + "/order_book/trades/"
            Request.get(url, data, callback)
        }
        
        public func ledgers(data: Parameters?, _ callback: @escaping Callback) {
            let url = serverUrl + "/ledgers/"
            Request.get(url, data, callback)
        }
        
        public func ledger(id: String, _ callback: @escaping Callback) {
            let url = serverUrl + "/ledgers/" + id
            Request.get(url, nil, callback)
        }
        
        public func ledgerEffects(id: String, data: Parameters?, _ callback: @escaping Callback) {
            let url = serverUrl + "/ledgers/" + id + "/effects/"
            Request.get(url, data, callback)
        }
        
        public func ledgerOffers(id: String, data: Parameters?, _ callback: @escaping Callback) {
            let url = serverUrl + "/ledgers/" + id + "/offers/"
            Request.get(url, data, callback)
        }
        
        public func ledgerOperations(id: String, data: Parameters?, _ callback: @escaping Callback) {
            let url = serverUrl + "/ledgers/" + id + "/operations/"
            Request.get(url, data, callback)
        }
        
        public func ledgerPayments(id: String, data: Parameters?, _ callback: @escaping Callback) {
            let url = serverUrl + "/ledgers/" + id + "/payments/"
            Request.get(url, data, callback)
        }
        
        public func effects(data: Parameters?, _ callback: @escaping Callback) {
            let url = serverUrl + "/effects/"
            Request.get(url, data, callback)
        }
        
        public func operations(data: Parameters?, _ callback: @escaping Callback) {
            let url = serverUrl + "/operations/"
            Request.get(url, data, callback)
        }
        
        public func operation(id: String, data: Parameters?, _ callback: @escaping Callback) {
            let url = serverUrl + "/operations/" + id
            Request.get(url, data, callback)
        }
        
        public func operationEffects(hash: String, data: Parameters?, _ callback: @escaping Callback) {
            let url = serverUrl + "/operations/" + hash + "/effects/"
            Request.get(url, data, callback)
        }
        
        public func payments(data: Parameters?, _ callback: @escaping Callback) {
            let url = serverUrl + "/payments/"
            Request.get(url, data, callback)
        }
        
        public func assets(data: Parameters?, _ callback: @escaping Callback) {
            let url = serverUrl + "/assets/"
            Request.get(url, data, callback)
        }
        
        public func submit(_ txHash: String, _ callback: @escaping Callback) {
            let data = ["tx": txHash]               // TxEnv.xdr.base64
            let url = serverUrl + "/transactions/"
            Request.post(url, data, callback)       // timeout=20
        }
        
        // TESTNET ONLY
        public func friendbot(address: String, _ callback: @escaping Callback) {
            let url = serverUrl + "/friendbot?addr=" + address
            Request.get(url, nil, callback)
        }
        
    }
}


// END
