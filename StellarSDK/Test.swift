//
//  Test.swift
//  StellarSDK
//
//  Created by Laptop on 1/23/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Foundation
import CryptoSwift


func testZero() {
    print("OK")
}


func testOne() {
    print("\n---- \(#function)\n")
    let data = Data(bytes: [0x01, 0x02, 0x03])
    print("Data: "  , data)
    print("Bytes: " , data.bytes)
    print("Hex: "   , data.bytes.toHexString())
    print("Base64: ", data.bytes.toBase64() ?? "?")
    
    // hash from bytes
    let bytes:Array<UInt8> = [0x01, 0x02, 0x03]
    let digest1 = bytes.md5()
    let digest2 = Digest.md5(bytes)
    print("MD5: ", digest1)
    print("MD5: ", digest2)
    
    // hash from data
    let data2 = Data(bytes: [0x01, 0x02, 0x03])
    let hash1 = data2.md5()
    let hash2 = data2.sha1()
    let hash3 = data2.sha224()
    let hash4 = data2.sha256()
    let hash5 = data2.sha384()
    let hash6 = data2.sha512()
    print("MD5"   , hash1)
    print("SHA1"  , hash2)
    print("SHA224", hash3)
    print("SHA256", hash4)
    print("SHA384", hash5)
    print("SHA512", hash6)
}

func testingEd25519() {
    let key  = Ed25519.generate() // (public,secret,seed)
    print("Key: ", key)
}

func testGetAccount() {
    print("\n---- \(#function)\n")
    let publicKey = "GAJ54B2Q73XHXMKLGUWNUQL5XZLIS3ML7MHRNICYBWBLQQDVESJJNNMJ"
    let server  = StellarSDK.Horizon.test
    server.account(address: publicKey) { response in
        print("Raw:", response.text)
    }
}

func testFriendbot() {
    print("\n---- \(#function)\n")
    let address = KeyPair.random().publicKey.base32
    let server  = StellarSDK.Horizon.test
    server.fundTestAccount(address: address) { response in
        print("Raw:", response.text)
    }
}

// END
