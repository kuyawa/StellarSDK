//
//  XdrKitTests.swift
//  StellarSDK
//
//  Created by Laptop on 2/2/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import XCTest
@testable import StellarSDK
@testable import CryptoSwift

class XdrKitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    
    override func tearDown() {
        super.tearDown()
        print("\n----")
    }
    
    
    //---- XDR
/*
    func testXdrEncodeUInt8() {
        print("\n---- \(#function)\n")
        let ini = UInt8(123)
        let xdr = ini.toXDR()
        let end = UInt8(xdr: xdr)
        print("Ini:", ini)
        print("Xdr:", xdr.bytes)
        print("B64:", xdr.base64)
        print("End:", end)
        print("Equal", ini==end)
        print()
        XCTAssertEqual(ini, end, "UInt8 not equal")
    }

    func testXdrEncodeUInt16() {
        print("\n---- \(#function)\n")
        let ini = UInt16(12345)
        let xdr = ini
        let end = UInt16(xdr: xdr)
        print("Ini:", ini)
        print("Xdr:", xdr.bytes)
        print("B64:", xdr.base64)
        print("End:", end)
        print("Equal", ini==end)
        print()
        XCTAssertEqual(ini, end, "UInt16 not equal")
    }
*/
    func testXdrEncodeUInt32() {
        print("\n---- \(#function)\n")
        let ini = UInt32(12345678)
        var xdr = ini.toXDR()
        let end = UInt32(xdrData: &xdr)
        print("Ini:", ini)
        print("Xdr:", xdr.bytes)
        print("B64:", xdr.base64)
        print("End:", end)
        print("Equal", ini==end)
        print()
        XCTAssertEqual(ini, end, "UInt32 not equal")
    }
    
    func testXdrEncodeUInt64() {
        print("\n---- \(#function)\n")
        let ini = UInt64(1234567890123456789)
        var xdr = ini.toXDR()
        let end = UInt64(xdrData: &xdr)
        print("Ini:", ini)
        print("Xdr:", ini.xdr.bytes)
        print("B64:", ini.xdr.base64)
        print("End:", end)
        print("Equal", ini==end)
        print()
        XCTAssertEqual(ini, end, "UInt32 not equal")
    }
/*
    func testXdrEncodeInt8() {
        print("\n---- \(#function)\n")
        let ini = Int8(-123)
        let xdr = ini.xdr
        let end = Int8(xdr: xdr)
        print("Ini:", ini)
        print("Xdr:", xdr.bytes)
        print("B64:", xdr.base64)
        print("End:", end)
        print("Equal", ini==end)
        print()
        XCTAssertEqual(ini, end, "UInt8 not equal")
    }
    
    func testXdrEncodeInt16() {
        print("\n---- \(#function)\n")
        let ini = Int16(-12345)
        let xdr = ini.xdr
        let end = Int16(xdr: xdr)
        print("Ini:", ini)
        print("Xdr:", xdr.bytes)
        print("B64:", xdr.base64)
        print("End:", end)
        print("Equal", ini==end)
        print()
        XCTAssertEqual(ini, end, "UInt16 not equal")
    }
*/
    func testXdrEncodeInt32() {
        print("\n---- \(#function)\n")
        let ini = Int32(-123456)
        var xdr = ini.toXDR()
        let end = Int32(xdrData: &xdr)
        print("Ini:", ini)
        print("Xdr:", xdr.bytes)
        print("B64:", xdr.base64)
        print("End:", end)
        print("Equal", ini==end)
        print()
        XCTAssertEqual(ini, end, "UInt32 not equal")
    }
    
    func testXdrEncodeInt64() {
        print("\n---- \(#function)\n")
        let ini = Int64(-1234567890)
        var xdr = ini.xdr
        let end = Int64(xdrData: &xdr)
        print("Ini:", ini)
        print("Xdr:", ini.xdr.bytes)
        print("B64:", ini.xdr.base64)
        print("End:", end)
        print("Equal", ini==end)
        print()
        XCTAssertEqual(ini, end, "UInt32 not equal")
    }
    
    func testXdrEncodeString() {
        print("\n---- \(#function)\n")
        let ini = "Test with unicode ©∆ end"
        var xdr = ini.toXDR()           // to xdr
        let end = String(xdrData: &xdr)  // and back
        print("Ini:", ini)
        print("Xdr:", xdr.bytes)
        print("B64:", xdr.base64)
        print("End:", end)
        print("Equal", ini==end)
        print()
        XCTAssertEqual(ini, end, "Strings not equal")
    }
    
    func testXdrEncodeBool() {
        print("\n---- \(#function)\n")
        let ini = true
        var xdr = ini.toXDR()
        let end = Bool(xdrData: &xdr)    // and back
        print("Ini:", ini)
        print("Xdr:", xdr.base64)
        print("End:", end)
        print("Equal", ini==end)
        print()
        XCTAssertEqual(ini, end, "Bool not equal")
    }
    
    func testXdrEncodeData() {
        print("\n---- \(#function)\n")
        let ini = Data([0, 1, 30, 255, 0])
        var xdr = ini.toXDR()
        let end = Data(xdrData: &xdr)
        print("Ini:", ini.bytes)
        print("Xdr:", xdr.bytes)
        print("B64:", xdr.base64)
        print("End:", end.bytes)
        print("Equal", ini==end)
        print()
        XCTAssertEqual(ini, end, "Data not equal")
    }
    
    func testXdrEncodeArrayInt() {
        print("\n---- \(#function)\n")
        let ini = Array<Int32>([0, 10, 20, -30, 40, 50, 0])
        var xdr = ini.toXDR()
        let end = Array<Int32>(xdrData: &xdr)
        print("Ini:", ini)
        print("Xdr:", xdr.bytes)
        print("B64:", xdr.base64)
        print("End:", end)
        print("Equal", ini==end)
        print()
        XCTAssertEqual(ini, end, "Int Array not equal")
    }
    
    func testXdrEncodeArrayString() {
        print("\n---- \(#function)\n")
        let ini = Array<String>(["Hello", "Stellar", "World", ".", ""])
        var xdr = ini.toXDR()
        let end = Array<String>(xdrData: &xdr)
        print("Ini:", ini)
        print("Xdr:", xdr.bytes)
        print("B64:", xdr.base64)
        print("End:", end)
        print("Equal", ini==end)
        print()
        XCTAssertEqual(ini, end, "String Array not equal")
    }
    
    
    func testXdrEncodeOptional() {
        print("\n---- \(#function)\n")
        let ini:String? = nil
        var xdr = ini.toXDR()
        let end:String? = String(xdrData: &xdr)
        print("Ini:", ini ?? "?")
        print("Xdr:", xdr.bytes)
        print("B64:", xdr.base64)
        print("End:", end ?? "?")
        print("Equal", ini==end)
        print()
        XCTAssertNil(ini, "Optional not nil")
        XCTAssertEqual(end, "", "String not empty")
    }
    
    func testXdrEncodeStruct() {
        struct testStruct: XDREncodableStruct {
            var name: String  = "test"
            var num1: UInt32  = 100001
            var num2: UInt64  = 123
            var num3: Int32   = 1234
            var flag: Bool    = true
            var list: [Int32] = [11,22,33]
            
            init(name: String, num1: UInt32, num2: UInt64, num3: Int32, flag: Bool, list: [Int32]) {
                self.name = name
                self.num1 = num1
                self.num2 = num2
                self.num3 = num3
                self.flag = flag
                self.list = list
            }
            
            init(xdrData: Data) {
                var xdr    = xdrData
                self.name  = String(xdrData: &xdr)
                self.num1  = UInt32(xdrData: &xdr)
                self.num2  = UInt64(xdrData: &xdr)
                self.num3  = Int32(xdrData: &xdr)
                self.flag  = Bool(xdrData: &xdr)
                self.list  = Array<Int32>(xdrData: &xdr)
            }
            
        }
        
        print("\n---- \(#function)\n")
        let ini = testStruct(name: "Jill", num1: 123456, num2: 123, num3: 12345, flag: true, list: [22,33,44])
        let xdr = ini.toXDR()
        let end = testStruct(xdrData: xdr)
        print("Ini:", ini)
        print("Xdr:", xdr.bytes)
        print("B64:", xdr.base64)
        print("End:", end)
        print("Equal", ini.name==end.name)
        print()
        XCTAssertEqual(ini.name, end.name, "Data not equal")
    }
   
    func testEncodeAsset() {
        print("\n---- \(#function)\n")
        let asset1 = Asset.Native
        print("AssetN:", asset1.xdr.bytes)
        print("AssetN:", asset1.xdr.base64)
        print()
        
        print("\nAssetD4----")
        let assetD4 = AssetData(assetCode: "USD", issuer: "GAJ54B2Q73XHXMKLGUWNUQL5XZLIS3ML7MHRNICYBWBLQQDVESJJNNMJ")
        print("\nAssetD4:", assetD4.xdr.bytes)
        print("AssetD4:", assetD4.xdr.base64)

        print("\nAssetD12----")
        let assetD12 = AssetData(assetCode: "SpecialToken", issuer: "GAJ54B2Q73XHXMKLGUWNUQL5XZLIS3ML7MHRNICYBWBLQQDVESJJNNMJ")
        print("\nAssetD12:", assetD12.xdr.bytes)
        print("AssetD12:", assetD12.xdr.base64)

        //let pk = KeyPair.getPublicKey("GAJ54B2Q73XHXMKLGUWNUQL5XZLIS3ML7MHRNICYBWBLQQDVESJJNNMJ")!
        //let code = DataFixed("USD".dataUTF8!, size: 4)
        //let asset2 = Asset.CreditAlphaNum4(AssetData(assetCode: code, issuer: pk))
        //let asset2 = Asset.CreditAlphaNum4(AssetData(assetCode: "KASH", issuer: "GAJ54B2Q73XHXMKLGUWNUQL5XZLIS3ML7MHRNICYBWBLQQDVESJJNNMJ")!)
        //let asset2 = Asset(assetCode: "USDX", issuer: pk)
        // AAAAAQAAAAFVU0QAAAAAAQAAAAAT3gdQ/u57sUs1LNpBfb5WiW2L+w8WoFgNgrhAdSSSlg==
        print("\nAsset2----")
        let asset2 = Asset(assetCode: "USDX", issuer: "GAJ54B2Q73XHXMKLGUWNUQL5XZLIS3ML7MHRNICYBWBLQQDVESJJNNMJ")
        print("\nAsset2:", asset2.xdr.bytes)
        print("Asset2:", asset2.xdr.base64)
        
        print("\nAsset3----")
        let asset3 = Asset(assetCode: "SpecialToken", issuer: "GAJ54B2Q73XHXMKLGUWNUQL5XZLIS3ML7MHRNICYBWBLQQDVESJJNNMJ")
        print("Asset3:", asset3.xdr.bytes)
        print("Asset3:", asset3.xdr.base64)
    }
    
    func testXdrEncodeInflation() {
        struct Transaction: XDREncodableStruct {
            var source      : String = "GAJ54B2Q73XHXMKLGUWNUQL5XZLIS3ML7MHRNICYBWBLQQDVESJJNNMJ"
            var fee         : UInt32 = 100
            var sequence    : UInt64 = 1
            var timeBounds  : Int32  = 0
            var memo        : String = "Infation"
            var ext         : Int32 = 0
            var operations  : [Operation] = []
            
            init() {}
            
            init(xdrData: inout Data, count: Int32 = 0) {
                var xdr = xdrData

                source      = String(xdrData: &xdr)
                fee         = UInt32(xdrData: &xdr)
                sequence    = UInt64(xdrData: &xdr)
                timeBounds  = Int32(xdrData: &xdr)
                memo        = String(xdrData: &xdr)
                ext         = Int32(xdrData: &xdr)
                operations  = Array<Operation>(xdrData: &xdr)
            }
        }
        
        struct Operation: XDRDecodable, XDREncodableStruct {
            var type: String = "setOptions"
            var inflationDest: String = "GACNHBPK6ZC77G545PQSQ2V7RWS5SQ4W56E2DNRBMPDFEQBQMTEH3XFW"
            
            init(type: String, inflationDest: String) {
                self.type = type
                self.inflationDest = inflationDest
            }
            
            init(xdrData: inout Data, count: Int32 = 0) {
                var xdr = xdrData
                
                type = String(xdrData: &xdr)
                inflationDest = String(xdrData: &xdr)
            }
            
        }
        
        print("\n---- \(#function)\n")
        let op  = Operation(type: "setOptions", inflationDest: "GACNHBPK6ZC77G545PQSQ2V7RWS5SQ4W56E2DNRBMPDFEQBQMTEH3XFW")
        //let trx = Transaction(source: "GAJ54B2Q73XHXMKLGUWNUQL5XZLIS3ML7MHRNICYBWBLQQDVESJJNNMJ", fee: UInt32(100), sequence: UInt64(1), time_bounds: Int32(0), memo: "Inflation", operations: [op], ext: Int32(0))
        var trx = Transaction()
        trx.operations.append(op)
        var xdr = trx.toXDR()
        let end = Transaction(xdrData: &xdr)
        print("Ini:", trx)
        print("Xdr:", trx.xdr.bytes)
        print("B64:", trx.xdr.base64)
        print("End:", end)
        print("Equal", trx.source==end.source)
        print()
        XCTAssertEqual(trx.source, end.source, "Data not equal")
    }

    // Builder.build returns a transaction like this one
    func testEncodeCreateAccount() {
        print("\n---- \(#function)\n")
        //let pubkey = "GDAKK4UKQM73BOE7ITYUM5YIWFT7YCZLNJBMDQVREMRWUUTBN7566HMN"
        let secret   = "SAOEFG5WDZAAIET3QIHR3W5A6YJIMT2EVRJO2ZAJJOI2IAOA4UIIRNOZ"
        let keyPair  = KeyPair.fromSecret(secret)!
        let source   = keyPair.publicKey
        let sourcepk = PublicKey.ED25519(DataFixed(source.data))
        let destin   = KeyPair.random()
        let destinG  = destin.stellarPublicKey
        let destinpk = PublicKey.ED25519(DataFixed(destin.publicKey.data))

        let inner = CreateAccountOp(destination: destinpk, startingBalance: 10)
        let body  = OperationBody.CreateAccount(inner)
        let op    = Operation(sourceAccount: sourcepk, body: body)

        let tx = Transaction(sourceAccount: sourcepk,
                             fee: 100,
                             seqNum: 99,
                             //timeBounds: TimeBounds(minTime: 0, maxTime: 0),
                             timeBounds: nil,
                             memo: Memo.Text("Test"),
                             operations: [op],
                             ext: 0)
        
        print("Funding account:", destinG)
        print()
        print("Source:", sourcepk.bytes)
        print("Source32:", sourcepk.base32)
        print("SourcePK:", sourcepk.xdr.base64)
        print("Destin:", destinpk.bytes)
        print("Destin32:", destinpk.base32)
        print("DestinPK:", destinpk.xdr.base64)
        print("Inner:", inner.xdr.base64)
        print("Body:", body.xdr.base64)
        print("Op:", op.toXDR().base64)
        print("\n---- TRANSACTION")
        print("Tx:", tx.xdr.base64)
        print("\n---- END TRANSACTION")
        //
    }

    // Builder.sign resturns a TX envelope
    func testEncodeTxSignature() {
        print("\n---- \(#function)\n")
        //let pubkey = "GDAKK4UKQM73BOE7ITYUM5YIWFT7YCZLNJBMDQVREMRWUUTBN7566HMN"
        let secret   = "SAOEFG5WDZAAIET3QIHR3W5A6YJIMT2EVRJO2ZAJJOI2IAOA4UIIRNOZ"
        let keyPair  = KeyPair.fromSecret(secret)!
        let source   = keyPair.publicKey
        let sourcepk = PublicKey.ED25519(DataFixed(source.data))
        let destin   = KeyPair.random()
        let destinG  = destin.stellarPublicKey
        let destinpk = PublicKey.ED25519(DataFixed(destin.publicKey.data))
        
        let inner = CreateAccountOp(destination: destinpk, startingBalance: 10)
        let body  = OperationBody.CreateAccount(inner)
        let op    = Operation(sourceAccount: sourcepk, body: body)
        
        let tx = Transaction(sourceAccount: sourcepk,
                             fee: 100,
                             seqNum: 99,
                             //timeBounds: TimeBounds(minTime: 0, maxTime: 0),
            timeBounds: nil,
            memo: Memo.Text("Test"),
            operations: [op],
            ext: 0)
        
        print("Funding account:", destinG)
        print()
        /*
        print("Source:", sourcepk.bytes)
        print("Source32:", sourcepk.base32)
        print("SourcePK:", sourcepk.xdr.base64)
        print("Destin:", destinpk.bytes)
        print("Destin32:", destinpk.base32)
        print("DestinPK:", destinpk.xdr.base64)
        print("Inner:", inner.xdr.base64)
        print("Body:", body.xdr.base64)
        print("Op:", op.toXDR().base64)
         */
        print("\n---- TRANSACTION")
        print("Tx:", tx.xdr.base64)
        print("---- END TRANSACTION")
        
        let signKey = keyPair.secretHash
        print("\nSignerKey", signKey.data.bytes)
        let hint = DataFixed(signKey.data.bytes.suffix(4).data) // .prefix(upTo: 4))
        print("\nHint", hint.data.bytes)
        let networkId = StellarSDK.Horizon.NetworkId.test
        let netHash = networkId.rawValue.dataUTF8!.sha256()
        print("\nNethash", netHash.bytes)
        let tagged = TaggedTransaction.TX(tx)
        print("\nTagged", tagged)
        print("\nTagged", tagged.xdr.base64)
        let payload = TransactionSignaturePayload(networkId: DataFixed(netHash.data), taggedTransaction: tagged)
        print("\nPayload", payload)
        print("\nPayload", payload.xdr.base64)
        let message = payload.xdr.sha256()
        print("\nMessage", message.bytes)
        print("\nMessage", message.xdr.base64)
        let signature = KeyPair.sign(message, DataFixed(signKey.data))
        print("\nSignature", signature?.bytes ?? "?")
        print("\nSignature", signature!.xdr.base64)
        let decorated = DecoratedSignature(hint: hint, signature: signature!)
        print("\nDecorated", decorated)
        print("\nDecorated", decorated.xdr.base64 )
        let envelope = TransactionEnvelope(tx: tx, signatures: [decorated])
        print("\nEnvelope", envelope)
        print("\nEnvXDR", envelope.xdr.base64)
        print()
    }
    
    func testPaymentOp() {
        print("\n---- \(#function)\n")
        let pubkey = "GDAKK4UKQM73BOE7ITYUM5YIWFT7YCZLNJBMDQVREMRWUUTBN7566HMN"
        //let secret   = "SAOEFG5WDZAAIET3QIHR3W5A6YJIMT2EVRJO2ZAJJOI2IAOA4UIIRNOZ"
        let sourcepk = KeyPair.getPublicKey(pubkey)!
        let destin   = KeyPair.random()
        let destinpk = KeyPair.getPublicKey(destin.stellarPublicKey)!
        
        //let inner = PaymentOp(destination: destinpk, asset: Asset.Native, amount: 10 * 10000000)
        let inner = PaymentOp(destination: destinpk, asset: Asset(assetCode: "USD", issuer: "GDAKK4UKQM73BOE7ITYUM5YIWFT7YCZLNJBMDQVREMRWUUTBN7566HMN")!, amount: 10 * 10000000)
        let body  = OperationBody.Payment(inner)
        let op    = Operation(sourceAccount: sourcepk, body: body)
        
        let tx = Transaction(sourceAccount: sourcepk,
                             fee: 100,
                             seqNum: 99,
                             timeBounds: nil,
                             memo: Memo.Text("Donation"),
                             operations: [op],
                             ext: 0)
        
        print("Paying account:", destin.stellarPublicKey)
        print()
        print("Inner:", inner.xdr.base64)
        print("Body:", body.xdr.base64)
        print("Op:", op.toXDR().base64)
        print("Tx:", tx.xdr.base64)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

// END
