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

enum HorizonErrors: Error {
    case connectionError
    case serverError
    case insufficientParameters
    case invalidParameters
    case invalidResponse
}

extension StellarSDK {
    
    open class Horizon {
        
        enum HorizonServer { case test, live }
        
        let HORIZON_LIVE = "https://horizon.stellar.org"
        let HORIZON_TEST = "https://horizon-testnet.stellar.org"
        
        public static var live: Horizon { return Horizon(.live) }
        public static var test: Horizon { return Horizon(.test) }
        
        var serverUrl = ""
        
        init(_ horizon: HorizonServer){
            if horizon == .live {
                serverUrl = HORIZON_LIVE
            } else {
                serverUrl = HORIZON_TEST
            }
        }
        
        
        // HTTP Request
        
        private class Request {
            
            
            //---- Public methods
            
            static func get(_ url: String, _ params: Parameters?, _ callback: @escaping Callback) {
                //print("GET: ", url)
                //let request = Request.URLBuild(url, params)
                var request = URLRequest(url: URL(string: url)!)
                print("GET",request.url!)
                URLSession.shared.dataTask(with: request) { data, response, error in
                    let result = self.handleResponse(data, response, error)
                    callback(result)
                }.resume()
            }
            
            static func post(_ url: String, _ params: Parameters?, _ callback: @escaping Callback) {
                // TODO:
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
                let agent   = "Stellar Bot 1.0"
                let encoded = URLEncode(uri, params)
                var request = URLRequest(url: encoded)
                request.setValue(agent, forHTTPHeaderField: "User-Agent")
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
                    result.text = text
                    // Accept both objects or arrays, arrays will be assigned to result.list
                    let json = try? JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                    if let dixy = json as? [String:Any] {
                        result.json = dixy
                        print(dixy)
                    } else if let list = json as? [Any] {
                        result.list = list
                        print(list)
                    }
                }
                
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
                    account._server = self
                    account.error = ErrorMessage(code: 500, text: "Server error")
                    callback(account)
                }
                if let status = response.json["status"] as? Int, status == 404 {
                    print("Account not found")
                    let account = AccountResponse()
                    account._server = self
                    account.error = ErrorMessage(code: 404, text: "Account not found")
                    callback(account)
                } else {
                    let account = StellarSDK.AccountResponse(response.json)
                    account._server = self
                    callback(account)
                }
            }
        }
        
        public func loadAccountTransactions(address: String, options: ListOptions?, callback: @escaping (_ transactions: TransactionsResponse) -> Void) {
            // TODO: Options cursor, order, limit
            let url = serverUrl + "/accounts/" + address + "/transactions/"
            Request.get(url, nil) { response in
                if let status = response.json["status"] as? Int, status == 404 {
                    print("Transactions not found")
                    let transactions = TransactionsResponse()
                    transactions._server = self
                    transactions.error = ErrorMessage(code: 404, text: "Transactions not found")
                    callback(transactions)
                } else {
                    let transactions = StellarSDK.TransactionsResponse(response.json)
                    transactions._server = self
                    callback(transactions)
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
        
        public func submit(_ hash: String, _ callback: @escaping Callback) {
            let data = ["tx": hash]                 // Tx Xdr envelope
            let url = serverUrl + "/transactions/"
            Request.post(url, data, callback)       // timeout=20
        }
        
        // TESTNET ONLY
        public func fundTestAccount(address: String, _ callback: @escaping Callback) {
            let url = serverUrl + "/friendbot?addr=" + address
            Request.get(url, nil, callback)
        }
        
    }
}


// END
