//
//  StellarTypes.swift
//  StellarSDK
//
//  Created by Laptop on 2/3/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Foundation

public typealias Hash    = Data // Max 32
public typealias UInt256 = Data // Max 32
//public typealias unsigned int uint32
//public typealias int int32
//public typealias unsigned hyper uint64
//public typealias hyper int64
public typealias Signature = Data    // Max 64. Variable size as the size depends on the signature scheme used
public typealias SignatureHint = Data    // Max  4
public typealias NodeID  = Data
//public typealias PublicKey   = NodeID  // Max 56

public enum CryptoKeyType {
    case ED25519
    case AuthTx
    case HashX
}

public enum PublicKeyType {
    case ED25519
}

public enum SignerKeyType {
    case ED25519
    case PreAuthTx
    case HashX
}

//let pk = PublicKey.ED25519("123".data(using: .utf8)!)
public enum PublicKey {
    case ED25519   (UInt256)
}

public enum SignerKey {
    case ED25519   (UInt256)
    case PreAuthTx (UInt256)
    case HashX     (UInt256)
}

public struct Curve25519Secret {
    public var key: Data = Data(count: 32)
}

public struct Curve25519Public {
    public var key: Data = Data(count: 32)
}

public struct HmacSha256Key {
    public var key: Data = Data(count: 32)
}

public struct HmacSha256Mac {
    public var mac: Data //[32]
}

// END
