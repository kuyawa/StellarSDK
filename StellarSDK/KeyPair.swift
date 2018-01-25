//
//  KeyPair.swift
//  StellarSDK
//
//  Created by Laptop on 1/23/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Foundation

enum VersionBytes: UInt8 {
    case publicKey   = 0x030  // G  48
    case secretKey   = 0x090  // S 144
    case transaction = 0x091  // T 145
    case sha256hash  = 0x095  // X 149
}

open class KeyPair {
    open var publicKey  : [UInt8] = [0x0]  // 32
    open var secretKey  : [UInt8] = [0x0]  // 32
    var startSeed  : [UInt8] = [0x0]  // 32
    var secretHash : [UInt8] = [0x0]  // 64
    
    open static func random() -> KeyPair {
        return KeyPair()
    }
    
    open static func fromSeed(_ seed: [UInt8]) -> KeyPair? {
        return KeyPair(seed: seed)
    }
    
    open static func fromSecret(_ secret: [UInt8]) -> KeyPair? {
        return KeyPair(secret: secret)
    }
    
    init() {
        let key    = Ed25519.generate()
        publicKey  = stellarKey(.publicKey, key.publicKey)
        secretKey  = stellarKey(.secretKey, key.startSeed)
        secretHash = key.secretKey
        startSeed  = key.startSeed
    }
    
    init?(seed: [UInt8]) {
        guard seed.count == 32 else { return nil }
        let key    = Ed25519.generate(seed: seed)
        publicKey  = stellarKey(.publicKey, key.publicKey)
        secretKey  = stellarKey(.secretKey, key.startSeed)
        secretHash = key.secretKey
        startSeed  = key.startSeed
    }
    
    init?(secret: [UInt8]) {
        guard secret.count == 35 else { return nil }
        // Validate prefix 'S'
        let prefix = secret[0]
        guard prefix == VersionBytes.secretKey.rawValue else { return nil }
        // Validate checksum == suffix
        let seed   = Array(secret[1..<33])
        let suffix = [secret[33], secret[34]]
        //let crc  = UInt16(secret[33]) << 8 | UInt16(secret[34])
        let crc    = ChecksumXmodem([prefix]+seed)
        let pByte0 = UInt8(crc >> 8)
        let pByte1 = UInt8(crc & 0x00ff)
        let check  = [pByte1, pByte0]
        guard suffix == check else { return nil }
        let key    = Ed25519.generate(seed: seed)
        publicKey  = stellarKey(.publicKey, key.publicKey)
        secretKey  = stellarKey(.secretKey, key.startSeed)
        secretHash = key.secretKey
        startSeed  = key.startSeed
    }
    
    private func stellarKey(_ version: VersionBytes, _ key: [UInt8]) -> [UInt8] {
        let pBytes   = Array(key)
        let pPrefix  = [version.rawValue]
        let pCrc     = ChecksumXmodem(pPrefix+pBytes)
        let pByte0   = UInt8(pCrc >> 8)
        let pByte1   = UInt8(pCrc & 0x00ff)
        let pSuffix  = [pByte1, pByte0]
        let pKey     = pPrefix + pBytes + pSuffix
        //let pResult  = pKey.base32
        return pKey
    }
}
