//
//  StellarSDKTests.swift
//  StellarSDKTests
//
//  Created by Laptop on 1/23/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import XCTest
@testable import StellarSDK
@testable import CryptoSwift

class StellarSDKTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }


    func testExample() {
        print("\n---- \(#function)\n")
        testOne()
        XCTAssert(true)
    }

    func testEd25519() {
        print("\n---- \(#function)\n")
        let key = Ed25519.generate()
        let pub = key.publicKey
        let sec = key.secretKey
        let sed = key.startSeed
        print("\npub:", pub)
        print("\nsec:", sec)
        print("\nsed:", sed)
        print("pub:", pub.base32)
        print("sec:", sec.base32)
        print("sed:", sed.base32)
        XCTAssert(true)
    }

    func testSeed() {
        enum VersionBytes: UInt8 {
            case publicKey   = 0x030  // G  48
            case secretKey   = 0x090  // S 144
            case transaction = 0x091  // T 145
            case sha256hash  = 0x095  // X 149
        }
        
        let newKey = Ed25519.generate()
        
        // Public key
        let pBytes   = Array(newKey.publicKey)
        let pPrefix  = [VersionBytes.publicKey.rawValue]
        let pCrc     = ChecksumXmodem(pPrefix+pBytes)
        let pByte0   = UInt8(pCrc >> 8)
        let pByte1   = UInt8(pCrc & 0x00ff)
        let pCrc8    = [pByte1, pByte0]
        let pKey     = pPrefix + pBytes + pCrc8
        let pResult  = pKey.base32
        
        // Secret key
        let sBytes   = Array(newKey.startSeed)
        let sPrefix  = [VersionBytes.secretKey.rawValue]
        let sCrc     = ChecksumXmodem(sPrefix+sBytes)
        let sByte0   = UInt8(sCrc >> 8)
        let sByte1   = UInt8(sCrc & 0x00ff)
        let sCrc8    = [sByte0, sByte1]
        let sKey     = sPrefix + sBytes + sCrc8
        let sResult  = sKey.base32
        
        print("PKey ", pResult)
        print("SKey ", sResult)
    }
    

    func testEdReverse() {
        print("\n---- \(#function)\n")
        // Generate random keys
        let key = Ed25519.generate()
        let pub = key.publicKey
        let sec = key.secretKey
        let sed = key.startSeed
        print("pub:", pub.base32)
        print("sec:", sec.base32)
        print("sed:", sed)
        // Generate keys from seed
        let newkey = Ed25519.generate(seed: sed)
        print("Public: ", newkey.publicKey.base32)
        print("Secret: ", newkey.secretKey.base32)
        print("Seeder: ", newkey.startSeed)
        // Compare keys, must match
        XCTAssertEqual(key.publicKey, newkey.publicKey)
        XCTAssertEqual(key.secretKey, newkey.secretKey)
        XCTAssertEqual(key.startSeed, newkey.startSeed)
    }

    func testKeyBySecret() {
        print("\n---- \(#function)\n")
        // Generate keypair
        let key = KeyPair.random()
        let pub = key.publicKey
        let sec = key.secretKey
        let sed = key.startSeed
        print("Public1:", pub.base32)
        print("Secret1:", sec.base32)
        print("Seeder1:", sed)
        // Generate keypair from secret key 
        let key2 = KeyPair.fromSecret(sec)!
        print("Public2:", key2.publicKey.base32)
        print("Secret2:", key2.secretKey.base32)
        print("Seeder2:", key2.startSeed)
        // Generate keypair from seed
        let key3 = KeyPair.fromSeed(sed)!
        print("Public3:", key3.publicKey.base32)
        print("Secret3:", key3.secretKey.base32)
        print("Seeder3:", key3.startSeed)
        XCTAssertEqual(key.publicKey, key2.publicKey)
        XCTAssertEqual(key.secretKey, key2.secretKey)
        XCTAssertEqual(key.startSeed, key2.startSeed)
        XCTAssertEqual(key.publicKey, key3.publicKey)
        XCTAssertEqual(key.secretKey, key3.secretKey)
        XCTAssertEqual(key.startSeed, key3.startSeed)
    }
    

    func testChallenge() {
        enum VersionBytes: UInt8 {
            case publicKey   = 0x030  // G  48
            case secretKey   = 0x090  // S 144
            case transaction = 0x091  // T 145
            case sha256hash  = 0x095  // X 149
        }
        
        let code:[UInt8] = [0,0,0,19,101,99,100,115,97,45,115,104,97,50,45,110,105,115,116,112,50,53,54,0,0,0,8,110,105,115,116,112]
        let key2 = KeyPair.fromSeed(code)!

        // Public key
        let pBytes   = code
        let pPrefix  = [VersionBytes.publicKey.rawValue]
        let pCrc     = ChecksumXmodem(pPrefix+pBytes)
        let pByte0   = UInt8(pCrc >> 8)
        let pByte1   = UInt8(pCrc & 0x00ff)
        let pCrc8    = [pByte1, pByte0]
        let pKey     = pPrefix + pBytes + pCrc8
        let pResult  = pKey.base32
        
        // Secret key
        let sBytes   = code
        let sPrefix  = [VersionBytes.secretKey.rawValue]
        let sCrc     = ChecksumXmodem(sPrefix+sBytes)
        let sByte0   = UInt8(sCrc >> 8)
        let sByte1   = UInt8(sCrc & 0x00ff)
        let sCrc8    = [sByte0, sByte1]
        let sKey     = sPrefix + sBytes + sCrc8
        let sResult  = sKey.base32
    
        //let key2 = KeyPair.fromSecret(code)!
        //let key2 = KeyPair.fromSecret(sKey)!
        
        print("PKey ", pResult)
        print("SKey ", sResult)
        print("PKy2 ", key2.publicKey.base32)
        print("SKy2 ", key2.secretKey.base32)
    }
    
    func testSignature() {
        let key = KeyPair.random()
        //let pub = key.publicKey
        let sec = key.secretKey
        //let sed = key.startSeed
        let msg = "Hello world"
        let buf = Array(msg.utf8)
        
        let sha = HMAC(key: Array(sec), variant: .sha256)
        let sig = try? sha.authenticate(buf)
        print()
        print(sig!)
        print(sig!.toBase64()!)
        print()

    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
