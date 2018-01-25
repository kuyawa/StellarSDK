//
//  Xdr.swift
//  StellarSDK
//
//  Created by Laptop on 1/24/18.
//  Copyright © 2018 Armonia. All rights reserved.
//
//----
//
// Port to Swift 3 of the excellent work by the Kin Foundation
// StellarKit - https://github.com/kinfoundation/StellarKit
//

import Foundation


// Handy extensions

extension Data { var base64: String { return self.base64EncodedString() } }

// bitWidth is available in Swift 4.0
extension UInt   { static var bitWidth:  Int { return MemoryLayout<UInt>.size   } }
extension UInt8  { static var bitWidth:  Int { return MemoryLayout<UInt8>.size  } }
extension UInt16 { static var bitWidth:  Int { return MemoryLayout<UInt16>.size } }
extension UInt32 { static var bitWidth:  Int { return MemoryLayout<UInt32>.size } }
extension UInt64 { static var bitWidth:  Int { return MemoryLayout<UInt64>.size } }
extension Int    { static var bitWidth:  Int { return MemoryLayout<Int>.size    } }
extension Int8   { static var bitWidth:  Int { return MemoryLayout<Int8>.size   } }
extension Int16  { static var bitWidth:  Int { return MemoryLayout<Int16>.size  } }
extension Int32  { static var bitWidth:  Int { return MemoryLayout<Int32>.size  } }
extension Int64  { static var bitWidth:  Int { return MemoryLayout<Int64>.size  } }

extension UInt   { var bitWidth: Int { return MemoryLayout.size(ofValue: self) } }
extension UInt8  { var bitWidth: Int { return MemoryLayout.size(ofValue: self) } }
extension UInt16 { var bitWidth: Int { return MemoryLayout.size(ofValue: self) } }
extension UInt32 { var bitWidth: Int { return MemoryLayout.size(ofValue: self) } }
extension UInt64 { var bitWidth: Int { return MemoryLayout.size(ofValue: self) } }
extension Int    { var bitWidth: Int { return MemoryLayout.size(ofValue: self) } }
extension Int8   { var bitWidth: Int { return MemoryLayout.size(ofValue: self) } }
extension Int16  { var bitWidth: Int { return MemoryLayout.size(ofValue: self) } }
extension Int32  { var bitWidth: Int { return MemoryLayout.size(ofValue: self) } }
extension Int64  { var bitWidth: Int { return MemoryLayout.size(ofValue: self) } }

//func sizeof <T> (_ : T.Type)    -> Int { return (MemoryLayout<T>.size) }                // Type
//func sizeof <T> (_ : T)         -> Int { return (MemoryLayout<T>.size) }                // Instance
//func sizeof <T> (_ value : [T]) -> Int { return (MemoryLayout<T>.size * value.count) }  // Array


// XDR

public protocol XDREncodable {
    var xdr: Data { get }
}

public protocol XDRDecodable {
    init(xdr: Data)
}

public protocol XDRCodable: XDREncodable, XDRDecodable { }


extension UInt8: XDRCodable {
    public var xdr: Data {
        return Data(bytes: [self])
    }
    
    public init(xdr: Data) {
        //let xdr = xdr
        var val: UInt8 = 0
        let count = UInt8.bitWidth / UInt8.bitWidth
        
        xdr.withUnsafeBytes { (pointer: UnsafePointer<UInt8>) -> Void in
            for i in 0..<count {
                //val *= 256
                val += UInt8(pointer.advanced(by: i).pointee)
            }
        }
        
        self = val
    }
}

extension UInt16: XDRCodable {
    public var xdr: Data {
        var val = self
        let div = UInt16(UInt8.max) + 1
        var all = [UInt8]()
        
        for _ in 0..<(self.bitWidth / UInt8.bitWidth) {
            all.append(UInt8(val % div))
            val /= div
        }
        
        return Data(bytes: all.reversed())
    }
    
    public init(xdr: Data) {
        //var xdr = xdr
        var val: UInt16 = 0
        let count = UInt16.bitWidth / UInt8.bitWidth
        
        xdr.withUnsafeBytes { (pointer: UnsafePointer<UInt8>) -> Void in
            for i in 0..<count {
                val *= 256
                val += UInt16(pointer.advanced(by: i).pointee)
            }
        }
        
        self = val
    }
}

extension UInt32: XDRCodable {
    public var xdr: Data {
        var val = self
        let div = UInt32(UInt8.max) + 1
        var all = [UInt8]()
        
        for _ in 0..<(self.bitWidth / UInt8.bitWidth) {
            all.append(UInt8(val % div))
            val /= div
        }
        
        return Data(bytes: all.reversed())
    }
    
    public init(xdr: Data) {
        //var xdr = xdr
        var val: UInt32 = 0
        let count = UInt32.bitWidth / UInt8.bitWidth
        
        xdr.withUnsafeBytes { (pointer: UnsafePointer<UInt8>) -> Void in
            for i in 0..<count {
                val *= 256
                val += UInt32(pointer.advanced(by: i).pointee)
            }
        }
        
        self = val
    }
}

extension UInt64: XDRCodable {
    public var xdr: Data {
        var val = self
        let div = UInt64(UInt8.max) + 1
        var all = [UInt8]()
        
        for _ in 0..<(self.bitWidth / UInt8.bitWidth) {
            all.append(UInt8(val % div))
            val /= div
        }
        
        return Data(bytes: all.reversed())
    }
    
    public init(xdr: Data) {
        //var xdr = xdr
        var val: UInt64 = 0
        let count = UInt64.bitWidth / UInt8.bitWidth
        
        xdr.withUnsafeBytes { (pointer: UnsafePointer<UInt8>) -> Void in
            for i in 0..<count {
                val *= 256
                val += UInt64(pointer.advanced(by: i).pointee)
            }
        }
        
        self = val
    }
}

extension Int8: XDRCodable {
    public var xdr: Data {
        return Data(bytes: [UInt8(bitPattern: self)])
    }
    
    public init(xdr: Data) {
        let val: UInt8 = xdr.first!
        self = Int8(bitPattern: val)
    }
}

extension Int16: XDRCodable {
    public var xdr: Data {
        var val = UInt16(bitPattern: self)
        let div = UInt16(UInt8.max) + 1
        var all = [UInt8]()
        
        for _ in 0..<(self.bitWidth / UInt8.bitWidth) {
            all.append(UInt8(val % div))
            val /= div
        }
        
        return Data(bytes: all.reversed())
    }
    
    public init(xdr: Data) {
        var val: UInt16 = 0
        let count = UInt16.bitWidth / UInt8.bitWidth
        
        xdr.withUnsafeBytes { (pointer: UnsafePointer<UInt8>) -> Void in
            for i in 0..<count {
                val *= 256
                val += UInt16(pointer.advanced(by: i).pointee)
            }
        }
        
        self = Int16(bitPattern: val)
    }
}

extension Int32: XDRCodable {
    public var xdr: Data {
        var val = UInt32(bitPattern: self)
        let div = UInt32(UInt8.max) + 1
        var all = [UInt8]()
        
        for _ in 0..<(self.bitWidth / UInt8.bitWidth) {
            all.append(UInt8(val % div))
            val /= div
        }
        
        return Data(bytes: all.reversed())
    }
    
    public init(xdr: Data) {
        var val: UInt32 = 0
        let count = UInt32.bitWidth / UInt8.bitWidth
        
        xdr.withUnsafeBytes { (pointer: UnsafePointer<UInt8>) -> Void in
            for i in 0..<count {
                val *= 256
                val += UInt32(pointer.advanced(by: i).pointee)
            }
        }
        
        self = Int32(bitPattern: val)
    }
}

extension Int64: XDRCodable {
    public var xdr: Data {
        var val = UInt64(bitPattern: self)
        let div = UInt64(UInt8.max) + 1
        var all = [UInt8]()
        
        for _ in 0..<(self.bitWidth / UInt8.bitWidth) {
            all.append(UInt8(val % div))
            val /= div
        }
        
        return Data(bytes: all.reversed())
    }
    
    public init(xdr: Data) {
        var val: UInt64 = 0
        let count = UInt64.bitWidth / UInt8.bitWidth
        
        xdr.withUnsafeBytes { (pointer: UnsafePointer<UInt8>) -> Void in
            for i in 0..<count {
                val *= 256
                val += UInt64(pointer.advanced(by: i).pointee)
            }
        }
        
        self = Int64(bitPattern: val)
    }
}

extension Int: XDRCodable {
    public var xdr: Data {
        var val = UInt(bitPattern: self)
        let div = UInt(UInt8.max) + 1
        var all = [UInt8]()
        
        for _ in 0..<(self.bitWidth / UInt8.bitWidth) {
            all.append(UInt8(val % div))
            val /= div
        }
        
        return Data(bytes: all.reversed())
    }
    
    public init(xdr: Data) {
        var val: UInt = 0
        let count = UInt.bitWidth / UInt8.bitWidth
        
        xdr.withUnsafeBytes { (pointer: UnsafePointer<UInt8>) -> Void in
            for i in 0..<count {
                val *= 256
                val += UInt(pointer.advanced(by: i).pointee)
            }
        }
        
        self = Int(bitPattern: val)
    }
}

extension String: XDRCodable {
    public var xdr: Data {
        let length = Int32(self.lengthOfBytes(using: .utf8))
        var all = length.xdr                         // start with length
        all.append(self.data(using: .utf8)!)         // append rest of string
        
        return all
    }
    
    public init(xdr: Data) {
        let length = UInt32(xdr: Data(xdr.bytes[0..<Int(4)]))  // first 4 bytes is string length
        guard length > 0 else { self = ""; return }            // Empty or malformed xdr
        let bytes  = Data(xdr.bytes[4..<4+Int(length)])          // Ommit first four chars
        self       = String(bytes: bytes, encoding: .utf8)!
    }
}

extension Bool: XDRCodable {
    public var xdr: Data {
        return Int32(self ? 1 : 0).xdr
    }
    
    public init(xdr: Data) {
        let val = Int32(xdr: xdr)
        self = (val != 0)
    }
}

extension Array: XDREncodable {
    public var xdr: Data {
        let length = UInt32(self.count)
        var val = length.xdr
        
        forEach {
            if let item = $0 as? XDREncodable {
                val.append(item.xdr)
            }
        }
        
        return val
    }
}

extension Array where Element: XDRCodable {
    public init(xdr: Data) {
        var xdr    = xdr
        let four   = Data(xdr.prefix(upTo: 4))
        let length = UInt32(xdr: four) // first four bytes is length
        var list   = [Element]()
        if length < 1 { self = list; return }
        
        xdr = xdr.advanced(by: 4)
        
        while xdr.count > 0 {
            let item = Element(xdr: xdr) // try to pass only bytes needed per type
            let next = item.xdr.count
            list.append(item)
            if next >= xdr.count { break }
            xdr = xdr.advanced(by: next)
        }
        
        self = list
    }
}


extension Data: XDRCodable {
    public var xdr: Data {
        var val = Int32(self.count).xdr
        val.append(self)

        return val
    }
    
    public init(xdr: Data) {
        let length = xdr.count
        guard length > 3 else { self = Data(); return }  // Malformed xdr, first 4 bytes is data length
        self = Data(xdr.bytes[4..<length])
    }
}


extension Optional: XDREncodable {
    public var xdr: Data {
        var val = Data()
        
        switch self {
        case .some(let item):
            if let this = item as? XDREncodable {
                val += Int32(1).xdr + this.xdr
            }
        case nil:
            val += Int32(0).xdr
        }
        
        return val
    }
}



// END
