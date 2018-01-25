//
//  Horizon.swift
//  StellarSDK
//
//  Created by Laptop on 1/24/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Foundation

struct Response {
    var status  = 200
    var error   = false
    var message = ""
    var raw     = ""
    var headers = [String:String]()
    var body    = ""
    var xdr     = ""
    var text    = ""
    var json    = [String:Any]()
    var list    = [Any]()
}


class Horizon {
    
    enum HorizonServer { case test, live }
    
    let HORIZON_LIVE = "https://horizon.stellar.org"
    let HORIZON_TEST = "https://horizon-testnet.stellar.org"
    
    static var live: Horizon { return Horizon(.live) }
    static var test: Horizon { return Horizon(.test) }
    
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
            print("GET: ", url)
            let request = Request.URLBuild(url, params)
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
    
    // SDK methods
    
    //func loadAccount(_ secret: String, _ callback: @escaping (_ account: Account) -> Void) {
        //
    //}
    
    //func submitTransaction(_ tranx: StellarSDK.Transaction, _ callback: @escaping Callback) {
        //
    //}
    
    
    //---- API methods
    
    func account(address: String, _ callback: @escaping Callback) {
        let url = serverUrl + "/accounts/" + address
        Request.get(url, nil, callback)
    }
    
    func accounts(data: Parameters?, _ callback: @escaping Callback) {
        let url = serverUrl + "/accounts/"
        Request.get(url, data, callback)
    }
    
    func accountEffects(address: String, data: Parameters?, _ callback: @escaping Callback) {
        let url = serverUrl + "/accounts/" + address + "/effects/"
        Request.get(url, data, callback)
    }
    
    func accountOffers(address: String, data: Parameters?, _ callback: @escaping Callback) {
        let url = serverUrl + "/accounts/" + address + "/offers/"
        Request.get(url, data, callback)
    }
    
    func accountOperations(address: String, data: Parameters?, _ callback: @escaping Callback) {
        let url = serverUrl + "/accounts/" + address + "/operations/"
        Request.get(url, data, callback)
    }
    
    func accountTransactions(address: String, data: Parameters?, _ callback: @escaping Callback) {
        let url = serverUrl + "/accounts/" + address + "/transactions/"
        Request.get(url, data, callback)
    }
    
    func accountPayments(address: String, data: Parameters?, _ callback: @escaping Callback) {
        let url = serverUrl + "/accounts/" + address + "/payments/"
        Request.get(url, data, callback)
    }
    
    func transactions(data: Parameters?, _ callback: @escaping Callback) {
        let url = serverUrl + "/transactions/"
        Request.get(url, data, callback)
    }
    
    func transaction(hash: String, _ callback: @escaping Callback) {
        let url = serverUrl + "/transactions/" + hash
        Request.get(url, nil, callback)
    }
    
    func transactionOperations(hash: String, data: Parameters?, _ callback: @escaping Callback) {
        let url = serverUrl + "/transactions/" + hash + "/operations/"
        Request.get(url, data, callback)
    }
    
    func transactionEffects(hash: String, data: Parameters?, _ callback: @escaping Callback) {
        let url = serverUrl + "/transactions/" + hash + "/effects/"
        Request.get(url, data, callback)
    }
    
    func transactionPayments(hash: String, data: Parameters?, _ callback: @escaping Callback) {
        let url = serverUrl + "/transactions/" + hash + "/payments/"
        Request.get(url, data, callback)
    }
    
    func orderbook(data: Parameters?, _ callback: @escaping Callback) {
        let url = serverUrl + "/order_book/"
        Request.get(url, data, callback)
    }
    
    func orderbookTrades(data: Parameters?, _ callback: @escaping Callback) {
        let url = serverUrl + "/order_book/trades/"
        Request.get(url, data, callback)
    }
    
    func ledgers(data: Parameters?, _ callback: @escaping Callback) {
        let url = serverUrl + "/ledgers/"
        Request.get(url, data, callback)
    }
    
    func ledger(id: String, _ callback: @escaping Callback) {
        let url = serverUrl + "/ledgers/" + id
        Request.get(url, nil, callback)
    }
    
    func ledgerEffects(id: String, data: Parameters?, _ callback: @escaping Callback) {
        let url = serverUrl + "/ledgers/" + id + "/effects/"
        Request.get(url, data, callback)
    }
    
    func ledgerOffers(id: String, data: Parameters?, _ callback: @escaping Callback) {
        let url = serverUrl + "/ledgers/" + id + "/offers/"
        Request.get(url, data, callback)
    }
    
    func ledgerOperations(id: String, data: Parameters?, _ callback: @escaping Callback) {
        let url = serverUrl + "/ledgers/" + id + "/operations/"
        Request.get(url, data, callback)
    }
    
    func ledgerPayments(id: String, data: Parameters?, _ callback: @escaping Callback) {
        let url = serverUrl + "/ledgers/" + id + "/payments/"
        Request.get(url, data, callback)
    }
    
    func effects(data: Parameters?, _ callback: @escaping Callback) {
        let url = serverUrl + "/effects/"
        Request.get(url, data, callback)
    }
    
    func operations(data: Parameters?, _ callback: @escaping Callback) {
        let url = serverUrl + "/operations/"
        Request.get(url, data, callback)
    }
    
    func operation(id: String, data: Parameters?, _ callback: @escaping Callback) {
        let url = serverUrl + "/operations/" + id
        Request.get(url, data, callback)
    }
    
    func operationEffects(hash: String, data: Parameters?, _ callback: @escaping Callback) {
        let url = serverUrl + "/operations/" + hash + "/effects/"
        Request.get(url, data, callback)
    }
    
    func payments(data: Parameters?, _ callback: @escaping Callback) {
        let url = serverUrl + "/payments/"
        Request.get(url, data, callback)
    }
    
    func assets(data: Parameters?, _ callback: @escaping Callback) {
        let url = serverUrl + "/assets/"
        Request.get(url, data, callback)
    }
    
    func submit(_ hash: String, _ callback: @escaping Callback) {
        let data = ["tx": hash]                 // Tx Xdr envelope
        let url = serverUrl + "/transactions/"
        Request.post(url, data, callback)       // timeout=20
    }
    
    // TESTNET ONLY
    func fundTestAccount(address: String, _ callback: @escaping Callback) {
        let url = serverUrl + "/friendbot?addr" + address
        Request.get(url, nil, callback)
    }
    
}

// END
