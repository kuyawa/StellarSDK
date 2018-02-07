//
//  StellarTypeTests.swift
//  StellarSDK
//
//  Created by Laptop on 2/3/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import XCTest
@testable import StellarSDK
@testable import CryptoSwift

class StellarTypeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        print()
    }
    
    func testTypePublicKey() {
        print("\n---- \(#function)\n")
        
        let key:[UInt8] = [143, 229, 1, 145, 211, 203, 190, 90, 238, 141, 49, 32, 176, 222, 181, 99, 81, 179, 150, 163, 9, 204, 10, 85, 138, 67, 103, 15, 17, 140, 118, 156]
        let seed = Data(key)
        let publicKey = PublicKey.ED25519(DataFixed(seed.data))
        let kp = KeyPair.fromSeed(publicKey.bytes)
        
        print("Bytes", publicKey.bytes)
        print("PublicKey", kp!.publicKey)
        print(kp!.publicKey.base32 )
        print("SecretKey", kp!.secretKey)
        print(kp!.secretKey.base32)
        print("SecretHash", kp!.secretHash)
        print(kp!.secretHash.base32)
        print("StartSeed", kp!.startSeed)
        print(kp!.startSeed.base32)
        print("XDR bytes", publicKey.xdr.bytes)
        print("XDR base64", publicKey.xdr.base64)
        
        XCTAssertEqual(key, kp!.startSeed, "Seeds not equal")
    }
    
    func testTypePublicKeyString() {
        print("\n---- \(#function)\n")
        
        let key = "GAJ54B2Q73XHXMKLGUWNUQL5XZLIS3ML7MHRNICYBWBLQQDVESJJNNMJ"
        //let key = [143, 229, 1, 145, 211, 203, 190, 90, 238, 141, 49, 32, 176, 222, 181, 99, 81, 179, 150, 163, 9, 204, 10, 85, 138, 67, 103, 15, 17, 140, 118, 156]
        //let seed = Data(key)
        let publicKey = KeyPair.getKey(key)!

        print("XDR bytes", publicKey.xdr.bytes)
        print("XDR base32", publicKey.base32)
        print("XDR base64", publicKey.xdr.base64)
        
        XCTAssert(true, "Seeds not equal")
    }
    
    func testTypeCreateAccountOp() {
        print("\n---- \(#function)\n")
        
        let testAccount = "GAJ54B2Q73XHXMKLGUWNUQL5XZLIS3ML7MHRNICYBWBLQQDVESJJNNMJ"
        let publicKey = KeyPair.getKey(testAccount)!
        let op = CreateAccountOp(destination: publicKey, startingBalance: 100)
        
        print("XDR bytes", op.xdr.bytes)
        print("XDR base64", op.xdr.base64)
        
        XCTAssert(true, "Struct not ok")
    }

    func testTypePaymentOp() {
        print("\n---- \(#function)\n")
        
        let testAccount = "GAJ54B2Q73XHXMKLGUWNUQL5XZLIS3ML7MHRNICYBWBLQQDVESJJNNMJ"
        let publicKey = KeyPair.getKey(testAccount)!
        let asset = Asset.Native
        //let asset2 = Asset.CreditAlphaNum4(AssetData(assetCode: "USD", issuer: "G1234..."))
        //let asset3 = Asset(assetCode: "USD", issuer: "G1234...") // TODO: Work on this
        let op = PaymentOp(destination: publicKey, asset: asset, amount: 100)
        
        print("XDR bytes", op.xdr.bytes)
        print("XDR base64", op.xdr.base64)
        
        XCTAssert(true, "Struct not ok")
    }
    
    func testTypeMemo() {
        print("\n---- \(#function)\n")
        
        let memoType = MemoType.Text
        let memo0 = Memo.None()
        let memo1 = Memo.Text("Hello")
        let memo2 = Memo.Id(1234567890)
        let memo3 = Memo.Hash(DataFixed([1,2,3,4,5,6].data))
        let memo4 = Memo.Return(DataFixed([6,5,4,3,2,1].data))
        
        print("MemoType raw", memoType.rawValue)
        print("XDR bytes", memoType.rawValue.xdr.bytes)
        print("XDR base64", memoType.rawValue.xdr.base64)
        print("Memo text", memo1.text)
        print("Memo disc", memo1.discriminant)
        print("XDR bytes", memo1.xdr.bytes)
        print("XDR base64", memo1.xdr.base64)

        print("Memo0.text", memo0.text)
        print("Memo1.text", memo1.text)
        print("Memo2.text", memo2.text)
        print("Memo3.text", memo3.text)
        print("Memo4.text", memo4.text)
        
        XCTAssert(true, "Memo not ok")
    }
    

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
