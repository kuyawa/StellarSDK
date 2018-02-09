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
@testable import Sodium

class UtilsTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
        let key  = Ed25519.generate() // (public,secret,seed)
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
    
    func testSignatureStuff() {
        let testPublic = "GDAKK4UKQM73BOE7ITYUM5YIWFT7YCZLNJBMDQVREMRWUUTBN7566HMN"
        let testSecret = "SAOEFG5WDZAAIET3QIHR3W5A6YJIMT2EVRJO2ZAJJOI2IAOA4UIIRNOZ"
        //let keyPair  = KeyPair.fromSeed(KeyPair.getSeed(testSecret)!.bytes)!
        print()
        print(testSecret.base32DecodedData!.bytes)
        print(testSecret.utf8)
        print(testSecret.data(using: .utf8)!.bytes)
        //let sec = keyPair.secretKey
        //let sec = PublicKey.ED25519(KeyPair.getSeed(testSecret)!)
        //let sec = KeyPair.getSeed(testSecret)!
        let pub = testPublic.base32DecodedData!.subdata(in: 1..<33)
        let sec = testSecret.base32DecodedData!.subdata(in: 1..<33)
        print(sec.bytes)
        //let msg = "Hello world"
        let dat = "Hello world".data(using: .utf8)!
        //let msg = "SAOEFG5WDZAAIET3QIHR3W5A6YJIMT2EVRJO2ZAJJOI2IAOA4UIIRNOZ"
        //let buf = Array(msg.utf8)
        
        let sodium = Sodium()!
        //let keyPair = sodium.sign.keyPair()!
        let keyPair = sodium.sign.keyPair(seed: sec)!
        print("---1")
        print(keyPair.publicKey) //32
        print(keyPair.publicKey.bytes)
        print(keyPair.secretKey) //64 sk+pk
        print(keyPair.secretKey.bytes)
        print("---2")
        let ini = Array(keyPair.secretKey.bytes.prefix(upTo: 32))
        let gkey = KeyPair.fromSeed(ini)
        print(ini)
        print(gkey!.publicKey)  //32
        print(gkey!.secretKey)  //32
        print(gkey!.secretHash) //64 sk+pk
        print(gkey!.startSeed)  //32 pk
        print()
        
        // Conclusion: sodium publicKey32,secretKey64 == my publicKey32,secretHash64
        // To generate keypair in sodium, use seed: my.secretkey
        // To sign in sodium use sk+pk: my.secrethash
        
        print()
        print("---3")
        let kp  = KeyPair.fromSecret(testSecret)!
        //let key = keyPair.secretKey.bytes
        //let sig1 = try? HMAC(key: key, variant: HMAC.Variant.sha256).authenticate(buf)
        //let sig1 = try? HMAC(key: sec.bytes, variant: HMAC.Variant.sha256).authenticate(buf)
        let sig1 = sodium.sign.signature(message: dat, secretKey: sec+pub)
        let sig2 = sodium.sign.signature(message: dat, secretKey: kp.secretHash.data)
        //let sig2 = sodium.sign.signature(message: dat, secretKey: Data(gkey!.secretHash))
        print((sec+pub).bytes)
        print(gkey!.secretHash)
        //let sig2 = sodium.sign.signature(message: dat, secretKey: sec+pub)
        //let sig2 = KeyPair.sign(msg.data(using: .utf8)!, sec)
        //let sig2 = sodium.sign.signature(message: msg, secretKey: sec)
        //let sig2 = sodium.sign.signature(message: buf, secretKey: sec)
        print("----4")
        
        //let message = "My Test Message".data(using:.utf8)!
        let sig0 = sodium.sign.signature(message: dat, secretKey: keyPair.secretKey)!
        print()
        print(sig0.bytes)
        print(sig0.base32)
        print(sig0.base64)
        if sodium.sign.verify(message: dat, publicKey: keyPair.publicKey, signature: sig0) {
            print("signature is valid")
        }
        print()
        //print(msg)
        //print(msg.data(using: .utf8)!.bytes)
        print()
        //print(sec.bytes)
        //print(sec.base32)
        print("----5")
        print()
        print(sig1!.bytes)
        print(sig1!.base64)
        print()
        print(sig2!.bytes)
        print(sig2!.base64)
        print()
    }
    
    func testSignature() {
        let testPublic = "GDAKK4UKQM73BOE7ITYUM5YIWFT7YCZLNJBMDQVREMRWUUTBN7566HMN"
        let testSecret = "SAOEFG5WDZAAIET3QIHR3W5A6YJIMT2EVRJO2ZAJJOI2IAOA4UIIRNOZ"
        let message    = "Hello world"
        let data       = message.dataUTF8!
        let keyPair    = KeyPair.fromSecret(testSecret)!
        let sodium     = Sodium()!

        print("\n--- Sign")
        print("PK", keyPair.publicKey)
        print("SK", keyPair.secretKey)
        print()
        let sig = sodium.sign.signature(message: data, secretKey: keyPair.secretHash.data)
        print("SIG", sig!.bytes)
        print("S64", sig!.base64)

        print("\n--- Verify")
        let pk = KeyPair.getSeed(testPublic)!
        let ok = sodium.sign.verify(message: data, publicKey: pk.data, signature: sig!)
        print(ok ? "signature is valid" : "signature is invalid")
        
        XCTAssert(ok, "Invalid signature")
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
    
    func testSodiumKeys() {
        let testPublic = "GDAKK4UKQM73BOE7ITYUM5YIWFT7YCZLNJBMDQVREMRWUUTBN7566HMN"
        let testSecret = "SAOEFG5WDZAAIET3QIHR3W5A6YJIMT2EVRJO2ZAJJOI2IAOA4UIIRNOZ"
        let pub = testPublic.base32DecodedData!.subdata(in: 1..<33)
        let sec = testSecret.base32DecodedData!.subdata(in: 1..<33)
        let pKey = KeyPair.getSeed(testPublic)!
        let sKey = KeyPair.getSeed(testSecret)!
        print()
        print("---0")
        print(pub.bytes)
        print(sec.bytes)
        print(pKey.bytes)
        print(sKey.bytes)
        
        let sodium = Sodium()!
        let keyPair1 = sodium.box.keyPair(seed: sKey)!  // DO NOT USE THIS!
        print()
        print("---1")
        print(keyPair1.publicKey)
        print(keyPair1.publicKey.bytes)
        print(keyPair1.secretKey)
        print(keyPair1.secretKey.bytes)
        
        let keyPair2 = sodium.sign.keyPair(seed: sKey)!  // USE THIS!
        print()
        print("---2")
        print(keyPair2.publicKey)
        print(keyPair2.publicKey.bytes)
        print(keyPair2.secretKey)
        print(keyPair2.secretKey.bytes)
    }
    
    func testVector() {
        var bytes = Vector<UInt8>(size: 4, value: 0)
        bytes[0] = 1
        bytes[1] = 2
        bytes[2] = 3
        bytes[3] = 1
        print(bytes)
        print(bytes.xdr)
        print(bytes.xdr.bytes)
        print(bytes.xdr.base64)
    }

    func testVectorData() {
        let value:UInt32 = 1
        let bytes = value.bytes()
        //var bytes = Data(count: 4)
        //bytes[0] = UInt8(value >> 24)
        //bytes[1] = UInt8(value >> 16)
        //bytes[2] = UInt8(value >>  8)
        //bytes[3] = UInt8(value % 256)
        print(bytes)
        print(bytes.xdr)
        print(bytes.xdr.bytes)
        print(bytes.xdr.base64)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
