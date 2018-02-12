//
//  UtilsTests.swift
//  StellarSDK
//
//  Created by Laptop on 2/6/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import XCTest
@testable import StellarSDK
@testable import CryptoSwift

class UtilsTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here.
    }
    
    override func tearDown() {
        // Put teardown code here.
        super.tearDown()
        print("\n----")
    }

    func testCyphers() {
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
    
    func testEd25519() {
        let key  = ED25519.generate() // (public,secret,seed)
        print("Key: ", key)
    }

    func testKeyPairRandom() {
        print("\n---- \(#function)\n")
        
        let kp = KeyPair()
        
        print(kp.stellarPublicKey)
        print(kp.stellarSecretKey)
        print(kp.stellarPublicHash)
        print(kp.stellarSecretHash)
        print(kp.publicKey)
        print(kp.secretKey)
        print(kp.startSeed)
        print(kp.secretHash)
        
        XCTAssert(true, "Random always works")
    }

    func testKeyPairSeeded() {
        print("\n---- \(#function)\n")
        
        let inipk = "GBGT3O2I3CRGC5AG5DOGJGBSB2HT7WFYTBH3DXIK4ZO7RDMHC5BCVKDX"
        let inisk = "SCYFOYGERJCIVLANX2N7JXXG33QXPTWQUPFIVVBKSOPJT3YJ7T5S77AN"
        let kp = KeyPair(seed: [176, 87, 96, 196, 138, 68, 138, 172, 13, 190, 155, 244, 222, 230, 222, 225, 119, 206, 208, 163, 202, 138, 212, 42, 147, 158, 153, 239, 9, 252, 251, 47])!
        
        print(inipk)
        print(inisk)
        print()
        print(kp.stellarPublicKey)
        print(kp.stellarSecretKey)
        print(kp.stellarPublicHash)
        print(kp.stellarSecretHash)
        print(kp.publicKey)
        print(kp.secretKey)
        print(kp.startSeed)
        print(kp.secretHash)
        
        XCTAssertEqual(inipk, kp.stellarPublicKey, "Public keys not equal")
        XCTAssertEqual(inisk, kp.stellarSecretKey, "Secret keys not equal")
    }
    
    func testKeyPairFromSecret() {
        print("\n---- \(#function)\n")
        
        let iniPub = "GDAKK4UKQM73BOE7ITYUM5YIWFT7YCZLNJBMDQVREMRWUUTBN7566HMN"
        let iniSec = "SAOEFG5WDZAAIET3QIHR3W5A6YJIMT2EVRJO2ZAJJOI2IAOA4UIIRNOZ"
        let kp = KeyPair.fromSecret(iniSec)!
        
        print(kp.stellarPublicKey)
        print(kp.stellarSecretKey)
        print(kp.publicKey)
        print(kp.secretKey)
        print(kp.startSeed)
        print(kp.secretHash)
        
        XCTAssertEqual(iniPub, kp.stellarPublicKey, "Keys don't match")
    }

    func testAccountFlags() {
        let flags1 = StellarSDK.AccountAuthorizationFlags(required: false, revocable: false, immutable: false)
        let flags2 = StellarSDK.AccountAuthorizationFlags(required: true,  revocable: false, immutable: false )
        let flags3 = StellarSDK.AccountAuthorizationFlags(required: false, revocable: false, immutable: true )
        let flags4 = StellarSDK.AccountAuthorizationFlags(required: true,  revocable: false, immutable: true )
        let flags5 = StellarSDK.AccountAuthorizationFlags(required: true,  revocable: true,  immutable: true )
        
        print(flags1.on, flags1.off)
        print(flags2.on, flags2.off)
        print(flags3.on, flags3.off)
        print(flags4.on, flags4.off)
        print(flags5.on, flags5.off)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
