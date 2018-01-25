//
//  Operations.swift
//  StellarSDK
//
//  Created by Laptop on 1/25/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Foundation

protocol Operation {
    func toXDR() -> Data
}

// let op = StellarSDK.Operations.CreateAccount()

extension StellarSDK {
    
    public class Operations {
        
        public class CreateAccount: Operation {
            var source      = ""
            var destination = ""
            var balance     = 0.0
            
            init() {}
            
            func toXDR() -> Data {
                return Data()
            }
            
        }
        
        public class Payment: Operation {
            var source  = ""
            var target  = ""
            var asset   = ""
            var amount  = 0.0
            
            init() {}
            
            func toXDR() -> Data {
                return Data()
            }
        }
    }
}

// END
