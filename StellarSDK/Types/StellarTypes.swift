//
//  StellarTypes.swift
//  StellarSDK
//
//  Created by Laptop on 2/3/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Foundation

typealias Hash = DataFixed           // Size 32
typealias UInt256 = DataFixed        // Size 32
typealias Signature = Data           // Max 64. Variable size as the size depends on the signature scheme used
typealias SignatureHint = DataFixed  // Size  4
typealias NodeID  = Data
typealias SecretKey = DataFixed      // Size 64 for signing

enum CryptoKeyType: Int32 {
    case ED25519 = 0
    case PreAuthTx
    case HashX
}

enum PublicKeyType: Int32 {
    case ED25519 = 0
}

enum PublicKey: XDREncodable, Equatable {
    case ED25519 (DataFixed) // Size 32
    
    var discriminant: Int32 {
        switch self {
        case .ED25519: return Int32(PublicKeyType.ED25519.rawValue)
        }
    }
    
    var xdr: Data { return self.toXDR() }
    
    func toXDR(count: Int32 = 0) -> Data {
        var xdr = discriminant.xdr
        
        switch self {
        case .ED25519 (let key): xdr.append(key.xdr)
        }
        
        return xdr
    }

    var base32: String {
        switch self {
        case .ED25519(let key): return key.data.base32
        }
    }
    
    var bytes: [UInt8] {
        switch self {
        case .ED25519(let key): return key.data.bytes
        }
    }
    
    var data: Data {
        switch self {
        case .ED25519(let key): return key.data
        }
    }
    
    public static func ==(lhs: PublicKey, rhs: PublicKey) -> Bool {
        switch (lhs, rhs) {
        case let (.ED25519(key1), .ED25519(key2)):
            return key1 == key2
        }
    }

}

enum SignerKeyType: Int32 {
    case ED25519 = 0
    case PreAuthTx
    case HashX
}

enum SignerKey {
    case ED25519   (UInt256)
    case PreAuthTx (UInt256)
    case HashX     (UInt256)
}

struct Curve25519Secret {
    var key: Data = Data(repeating: 0, count: 32)
}

struct Curve25519Public {
    var key: Data = Data(repeating: 0, count: 32)
}

struct HmacSha256Key {
    var key: Data = Data(repeating: 0, count: 32)
}

struct HmacSha256Mac {
    var mac: Data = Data(repeating: 0, count: 32)
}

// END
