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
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
