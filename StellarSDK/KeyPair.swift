//
//  KeyPair.swift
//  StellarSDK
//
//  Created by Laptop on 1/23/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Foundation
import CryptoSwift
import Sodium

enum VersionBytes: UInt8 {
    case publicKey   = 0x030  // G  48
    case secretKey   = 0x090  // S 144
    case transaction = 0x091  // T 145
    case sha256hash  = 0x095  // X 149
}

class KeyPair {
    var publicKey         : [UInt8] = [0x0]  // 32 ED25519 public bytes
    var secretKey         : [UInt8] = [0x0]  // 32 ED25519 secret bytes
    var secretHash        : [UInt8] = [0x0]  // 64 ED25519 secret+public bytes
    var startSeed         : [UInt8] = [0x0]  // 32 ED25519 secret bytes (not used, same as secret)
    var stellarPublicHash : [UInt8] = [0x0]  // 35 Stellar public bytes prefix+pub+crc
    var stellarSecretHash : [UInt8] = [0x0]  // 35 Stellar secret bytes prefix+sec+crc
    var stellarPublicKey  : String { return stellarPublicHash.base32 }  // G12345...
    var stellarSecretKey  : String { return stellarSecretHash.base32 }  // S98765...
    
    static func random() -> KeyPair {
        return KeyPair()
    }
    
    static func fromSeed(_ seed: [UInt8]) -> KeyPair? {
        return KeyPair(seed: seed)
    }
    
    static func fromSecret(_ secret: [UInt8]) -> KeyPair? {
        return KeyPair(secret: secret)
    }
    
    static func fromSecret(_ secret: String) -> KeyPair? {
        guard secret.characters.count == 56 else { return nil }
        guard let seed = KeyPair.getSeed(secret) else { return nil }
        return KeyPair(seed: seed.bytes)
    }
    
    static func getSeed(_ key: String) -> Data? {
        guard key.characters.count == 56 else { return nil }
        guard let bytes = key.base32DecodedData, bytes.count > 32 else { return nil }
        //print("Bytes", bytes.bytes)
        let data = bytes.subdata(in: 1..<33)
        return data
    }
    
    static func getPublicKey(_ key: String) -> PublicKey? {
        guard let seed = getSeed(key) else { return nil }
        let publicKey = PublicKey.ED25519(DataFixed(seed))
        return publicKey
    }
    
    static func getSignerKey(_ secret: String) -> SecretKey? {
        guard let keyPair = KeyPair.fromSecret(secret) else { return nil }
        let signerKey = DataFixed(keyPair.secretHash.data)
        return signerKey
    }
    
    convenience init() {
        let key = Ed25519.generate()
        self.init(key: key)
    }
    
    convenience init?(seed: [UInt8]) {
        guard seed.count == 32 else { return nil }
        let key = Ed25519.generate(seed: seed)
        self.init(key: key)
    }
    
    convenience init?(secret: [UInt8]) {
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
        self.init(key: key)
    }
    
    init(key: KeyBase) {
        publicKey  = key.publicKey
        secretKey  = key.startSeed
        secretHash = key.secretKey
        startSeed  = key.startSeed
        stellarPublicHash = stellarPublicKey(key.publicKey)
        stellarSecretHash = stellarSecretKey(key.startSeed)
    }

    private func stellarPublicKey(_ key: [UInt8]) -> [UInt8] {
        return stellarKey(.publicKey, key)
    }
    
    private func stellarSecretKey(_ key: [UInt8]) -> [UInt8] {
        return stellarKey(.secretKey, key)
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
    
    // Sodium
    // To generate keypair in sodium, use seed: kp.secretkey
    // To sign in sodium use sk+pk: kp.secrethash
    static func sign(_ message: Data, _ key: SecretKey) -> Data? {
        let signature = Sodium()?.sign.signature(message: message, secretKey: key.data)
        return signature
    }

    // CryptoSwift
    static func signx(_ message: Data, _ key: SecretKey) -> Data? {
        guard let signature = try? HMAC(key: key.data.bytes, variant: .sha256).authenticate(message.bytes) else { return nil }
        return Data(signature)
    }

}
