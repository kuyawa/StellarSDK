//
//  Utils.swift
//  StellarSDK
//
//  Created by Laptop on 1/23/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Foundation

extension String {
    var dataUTF8: Data? { return self.data(using: .utf8) }

    var urlEncodedX: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var urlEncoded: String {
        var allowedQueryParamAndKey = NSMutableCharacterSet.urlQueryAllowed
        allowedQueryParamAndKey.remove(charactersIn: ";/?:@&=+$, ")
        
        return self.addingPercentEncoding(withAllowedCharacters: allowedQueryParamAndKey)!
    }

}

struct Vector<T> : XDREncodable {
    enum VectorError: Error {
        case outOfRange
        case arrayOverflow
    }
    
    private var size: Int
    private var value: T
    private var array: [T]
    private (set) var count = 0
    
    init(size: Int, value: T) {
        self.size = size
        self.value = value
        self.array = [T](repeating: value, count: size)
    }
    
    func inRange(_ index: Int)  -> Bool {
        return index >= 0 && index < size
    }
    
    subscript(index: Int) -> T {
        // Subscripts can't throw
        get {
            assert(inRange(index), "Index out of range")
            return array[index]
        }
        set(newValue) {
            assert(inRange(index), "Index out of range")
            array[index] = newValue
            count = max(index,count)
        }
    }
    
    mutating func append(_ element: T) throws {
        guard count < size else { throw VectorError.arrayOverflow }
        array[count] = element
        count += 1
    }
    
    // TODO: RemoveAndPack would nil a pos then pack at the end, useful in loops
    
    mutating func remove(_ index: Int) throws -> T {
        assert(inRange(index), "Index out of range")
        //guard index >= 0 && index < count else { throw VectorError.outOfRange }
        count -= 1
        let result = array[index]
        for pos in index..<count {
            array[pos] = array[pos+1]
        }
        array[count] = value
        return result
    }
    
    mutating func removeAll() {
        for i in 0..<count {
            array[i] = value
        }
        count = 0
    }
    
    var xdr: Data { return toXDR() }
    
    func toXDR(count: Int32 = 0) -> Data {
        return array.xdr
    }
}


// Zero-fill right shift
//infix operator >>> : BitwiseShiftPrecedence
//func >>> (lhs: UInt16, rhs: UInt16) -> Int16 {
//    return UInt16(bitPattern: UInt16(bitPattern: UInt16(lhs)) >> UInt16(rhs))
//}
//func >>> (lhs: UInt8, rhs: UInt8) -> UInt8 {
//    return UInt8(bitPattern: UInt8(bitPattern: UInt8(lhs)) >> UInt8(rhs))
//}



//----

//extension Sequence where Self.Iterator == UInt8, Self.Iterator == Int {
extension Sequence where Iterator.Element == UInt8 {
    public var base32: String {
        let bytes = Array(self)
        return base32Encode(bytes)
    }
}

extension Sequence where Iterator.Element == UInt8 {
    public var data: Data {
        let bytes = Array(self)
        return Data(bytes: bytes)
    }
}


