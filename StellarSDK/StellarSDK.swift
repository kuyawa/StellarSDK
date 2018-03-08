//
//  StellarSDK.swift
//  StellarSDK
//
//  Created by Laptop on 1/24/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Foundation

public typealias Parameters = [String: Any?]
public typealias Callback   = (_ response: Response) -> Void

public struct ErrorMessage {
    public var code : Int    = 0
    public var text : String = ""
}

public enum SortOrder {
    case asc
    case desc
}

public struct ListOptions {
    public var cursor : String    = ""
    public var limit  : Int       = 10
    public var order  : SortOrder = .desc
}


public class StellarSDK {
    
    public static func usePublicNetwork() -> Horizon {
        return Horizon(.live)
    }
    
    public static func useTestNetwork() -> Horizon {
        return Horizon(.test)
    }
    
    public static func ErrorResponse(code: Int, message: String) -> Response {
        var response     = Response()
        response.error   = true
        response.status  = code
        response.message = message
        
        return response
    }
    
    public struct Utils {
        public typealias Rational = (n: Int, d: Int)
        
        public static func rational(_ num: Double, withPrecision eps: Double = 1.0E-7) -> Rational {
            var x = num
            var a = x.rounded(.down)
            var (h1, k1, h, k) = (1, 0, Int(a), 1)
            
            while x - a > eps * Double(k) * Double(k) {
                x = 1.0/(x - a)
                a = x.rounded(.down)
                (h1, k1, h, k) = (h, k, h1 + Int(a) * h, k1 + Int(a) * k)
            }
            
            return (h, k)
        }

        // Best solution
        public static func rationalPrice(_ num: Double, reversed: Bool = false) -> Price {
            let fraction = rational(num)
            let num = Int32(fraction.n)
            let den = Int32(fraction.d)
            
            if reversed { return Price(n: den, d: num) }
            return Price(n: num, d: den)
        }

        static func priceFraction(_ price: Double, reversed: Bool? = false) -> Price {
            let reversed = reversed ?? false
            let ndecs = min(7, price.decs)  // count decimals ignoring trailing zeroes
            let ntens = NSDecimalNumber(decimal: pow(Decimal(10), ndecs)).doubleValue
            let num: Int32 = Int32(1 * ntens)
            let den: Int32 = Int32(price * ntens)
            //print(num, den)
            let (n, d) = simplify(num, den)
            //print(n, d)
            var price = Price(n: n, d: d)
            if reversed { price = Price(n: d, d: n) }

            return price
        }
        
        static func Json(_ text: String) -> [String: Any]? {
            guard let data = text.data(using: .utf8) else { return nil }
            var dixy: [String: Any]?
            
            do {
                dixy = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            } catch {
                print("JSON.error: ", error)
                return nil
            }
            
            return dixy
        }
    }
}


// END
