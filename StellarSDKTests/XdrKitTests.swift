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
        print("Xdr:", xdr.bytes)
        print("B64:", xdr.base64)
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
        let ini = Int32(-12345678)
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
        let ini = Int64(-1234)
        var xdr = ini.toXDR()
        let end = Int64(xdrData: &xdr)
        print("Ini:", ini)
        print("Xdr:", xdr.bytes)
        print("B64:", xdr.base64)
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
        print("Xdr:", xdr.bytes)
        print("B64:", xdr.base64)
        print("End:", end)
        print("Equal", trx.source==end.source)
        print()
        XCTAssertEqual(trx.source, end.source, "Data not equal")
    }


    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

// END
