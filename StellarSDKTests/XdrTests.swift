//
//  XdrTests.swift
//  StellarSDK
//
//  Created by Laptop on 1/24/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import XCTest
@testable import StellarSDK
@testable import CryptoSwift

class XdrTests: XCTestCase {

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
        let xdr = ini.xdr
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
        let xdr = ini.xdr
        let end = UInt16(xdr: xdr)
        print("Ini:", ini)
        print("Xdr:", xdr.bytes)
        print("B64:", xdr.base64)
        print("End:", end)
        print("Equal", ini==end)
        print()
        XCTAssertEqual(ini, end, "UInt16 not equal")
    }
    
    func testXdrEncodeUInt32() {
        print("\n---- \(#function)\n")
        let ini = UInt32(12345678)
        let xdr = ini.xdr
        let end = UInt32(xdr: xdr)
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
        let xdr = ini.xdr
        let end = UInt64(xdr: xdr)
        print("Ini:", ini)
        print("Xdr:", xdr.bytes)
        print("B64:", xdr.base64)
        print("End:", end)
        print("Equal", ini==end)
        print()
        XCTAssertEqual(ini, end, "UInt32 not equal")
    }
    
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
    
    func testXdrEncodeInt32() {
        print("\n---- \(#function)\n")
        let ini = Int32(-12345678)
        let xdr = ini.xdr
        let end = Int32(xdr: xdr)
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
        let ini = Int64(-123456789012345678)
        let xdr = ini.xdr
        let end = Int64(xdr: xdr)
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
        let xdr = ini.xdr           // to xdr
        let end = String(xdr: xdr)  // and back
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
        let xdr = ini.xdr           // to xdr
        let end = Bool(xdr: xdr)    // and back
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
        let xdr = ini.xdr
        let end = Data(xdr: xdr)
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
        let xdr = ini.xdr
        let end = Array<Int32>(xdr: xdr)
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
        let xdr = ini.xdr
        let end = Array<String>(xdr: xdr)
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
        let xdr = ini.xdr
        let end:String? = String(xdr: xdr)
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
            var name: String = "test"
            var num1: Int    = 100001
            var num2: UInt16 = 123
            var num3: Int32  = 1234
            var flag: Bool   = true
            var list: [Int]  = [11,22,33]
            
            init(name: String, num1: Int, num2: UInt16, num3: Int32, flag: Bool, list: [Int]) {
                self.name = name
                self.num1 = num1
                self.num2 = num2
                self.num3 = num3
                self.flag = flag
                self.list = list
            }
            
            init(xdr: Data) {
                let reader = XDRReader(xdr)
                self.name  = reader.getString()
                self.num1  = reader.getInt()
                self.num2  = reader.getUInt16()
                self.num3  = reader.getInt32()
                self.flag  = reader.getBool()
                self.list  = reader.getArray()
            }
            
        }
        
        print("\n---- \(#function)\n")
        let ini = testStruct(name: "Jill", num1: 123456, num2: 123, num3: 12345, flag: true, list: [22,33,44])
        let xdr = ini.xdr
        let end = testStruct(xdr: xdr)
        print("Ini:", ini)
        print("Xdr:", xdr.bytes)
        print("B64:", xdr.base64)
        print("End:", end)
        print("Equal", ini.name==end.name)
        print()
        XCTAssertEqual(ini.name, end.name, "Data not equal")
    }
    
    func testXdrEncodeInflations() {
        struct Transaction: XDREncodableStruct {
            var source      : String  // String[56]
            var fee         : UInt32 = 100
            var sequence    : UInt64 = 1
            var time_bounds : Int? = nil
            var memo        : String = "Infation"
            var operations  : [Operation]
            var ext         : Int32 = 0
            
            static func fromXDR(xdr: Data) -> Transaction {
                let reader = XDRReader(xdr)
                let tx = Transaction(
                    source: reader.getString(),
                    fee: reader.getUInt32(),
                    sequence: reader.getUInt64(),
                    time_bounds: reader.getInt(),
                    memo: reader.getString(),
                    operations: reader.getArray(),
                    ext: reader.getInt32()
                )
                
                return tx
            }
        }
        
        struct Operation: XDRCodable, XDREncodableStruct {
            var type: String = "setOptions"
            var inflationDest: String = "GACNHBPK6ZC77G545PQSQ2V7RWS5SQ4W56E2DNRBMPDFEQBQMTEH3XFW"
            
            init(type: String, inflationDest: String) {
                self.type = type
                self.inflationDest = inflationDest
            }
            
            init(xdr: Data) {
                let reader = XDRReader(xdr)
                self.type = reader.getString()
                self.inflationDest = reader.getString()
            }
            
        }
        
        print("\n---- \(#function)\n")
        let op  = Operation(type: "setOptions", inflationDest: "GACNHBPK6ZC77G545PQSQ2V7RWS5SQ4W56E2DNRBMPDFEQBQMTEH3XFW")
        let trx = Transaction(source: "GAJ54B2Q73XHXMKLGUWNUQL5XZLIS3ML7MHRNICYBWBLQQDVESJJNNMJ", fee: 100, sequence: 1, time_bounds: 0, memo: "Inflation", operations: [op], ext: 0)
        //let trx = Transaction()
        //trx.operations.append(op)
        let xdr = trx.xdr
        let end = Transaction.fromXDR(xdr: xdr)
        print("Ini:", trx)
        print("Xdr:", xdr.bytes)
        print("B64:", xdr.base64)
        print("End:", end)
        print("Equal", trx.source==end.source)
        print()
        XCTAssertEqual(trx.source, end.source, "Data not equal")
    }

    
    func testXdrReader() {
        let ini1 = "String1"
        let ini2 = "String2"
        let xdr  = XDR(ini1, ini2)!
        let reader = XdrReader(xdrBytes: xdr)
        let str1 = reader.readString()!
        let str2 = reader.readString()!
        print(ini1)
        print(ini2)
        print(xdr)
        print(str1)
        print(str2)
    }

    func testXdrArray() {
        let ini = ["String1", "String2"]
        let xdr = XDR(ini)!
        let reader = XdrReader(xdrBytes: xdr)
        let str1 = reader.readString()!
        let str2 = reader.readString()!
        print(ini)
        print(xdr)
        print(str1)
        print(str2)
    }
    
    func testXdrStruct() {
        struct test: XdrWritable {
            var txt = "Test"
            var num:Int32 = 123
            
            func writeTo(writer: XdrWriter) {
                writer.writeString(txt)
                writer.writeInt32(num)
            }
        }
        
        let ini = test()
        let wrt = XdrWriter()
        ini.writeTo(writer: wrt)
        print(wrt.xdrBytes.toBase64()!)
        
        let rdr = XdrReader(xdrBytes: wrt.xdrBytes)
        var tst = test()
        tst.txt = rdr.readString()!
        tst.num = rdr.readInt32()!
        print(tst)
    }
*/
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
