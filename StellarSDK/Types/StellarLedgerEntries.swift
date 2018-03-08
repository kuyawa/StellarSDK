//
//  StellarLedgerEntries.swift
//  StellarSDK
//
//  Created by Laptop on 2/3/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Foundation

public typealias AccountID = PublicKey  // Max 56
typealias Thresholds       = Data       // Max  4
typealias String32         = String     // Max 32
typealias String64         = String     // Max 64
typealias DataValue        = Data       // Max 64
typealias SequenceNumber   = UInt64     // Max UInt64.max
typealias AssetCode4       = String     // Max  4
typealias AssetCode12      = String     // Max 12
typealias Reserved         = Int32      // Reserved for future use

// CONSTANTS

let MASK_ACCOUNT_FLAGS    = 0x7  // mask for all valid flags
let MASK_TRUSTLINE_FLAGS  = 1    // mask for all trustline flags
let MASK_OFFERENTRY_FLAGS = 1    // Mask for OfferEntry flags


public enum AssetType: Int32 {
    case Native = 0
    case CreditAlphaNum4
    case CreditAlphaNum12
}

public struct AssetData: XDREncodableStruct, Equatable {
    var assetCode : DataFixed
    var issuer    : AccountID
    
    public init?(assetCode: String, issuer: String) {
        guard let publicKey = KeyPair.getPublicKey(issuer) else { return nil }
        let size = assetCode.characters.count < 5 ? 4 : 12
        self.assetCode = DataFixed(assetCode.dataUTF8!, size: size)
        self.issuer = publicKey
    }
    
    public init(assetCode: DataFixed, issuer: PublicKey) {
        self.assetCode = assetCode
        self.issuer = issuer
    }
    
    public static func ==(lhs: AssetData, rhs: AssetData) -> Bool {
        return (lhs.assetCode == rhs.assetCode && lhs.issuer == rhs.issuer)
    }
}

public enum Asset: XDREncodable, Equatable {
    case Native
    case CreditAlphaNum4  (AssetData)  // 1..4
    case CreditAlphaNum12 (AssetData)  // 5..12
    // add other asset types here in the future
    
    public init?(assetCode: String, issuer: String) {
        guard let publicKey = KeyPair.getPublicKey(issuer) else { return nil }
        self.init(assetCode: assetCode, issuer: publicKey)
    }
    
    public init?(assetCode: String, issuer: PublicKey) {
        if assetCode.characters.count < 5 {
            let asset = AssetData(assetCode: DataFixed(assetCode.dataUTF8!, size: 4), issuer: issuer)
            self = .CreditAlphaNum4(asset)
        } else if assetCode.characters.count < 13 {
            let asset = AssetData(assetCode: DataFixed(assetCode.dataUTF8!, size: 12), issuer: issuer)
            self = .CreditAlphaNum12(asset)
        } else {
            self = .Native
        }
    }
    
    var discriminant: Int32 {
        switch self {
        case .Native: return AssetType.Native.rawValue
        case .CreditAlphaNum4: return AssetType.CreditAlphaNum4.rawValue
        case .CreditAlphaNum12: return AssetType.CreditAlphaNum12.rawValue
        }
    }

    public func toXDR(count: Int32 = 0) -> Data {
        var xdr = discriminant.xdr
        
        switch self {
        case .Native: break
        case .CreditAlphaNum4(let alpha4): xdr.append(alpha4.xdr)
        case .CreditAlphaNum12(let alpha12): xdr.append(alpha12.xdr)
        }
        
        //return Data(xdr.suffix(from: 4)) // Weird ahck to avoid first bytes?
        return xdr
    }
    
    public static func ==(lhs: Asset, rhs: Asset) -> Bool {
        return lhs.isEqual(asset: rhs)
    }

    func isEqual(asset: Asset) -> Bool {
        switch self {
        case .Native: return asset == .Native
        case .CreditAlphaNum4(let asset1):
            if case .CreditAlphaNum4(let asset2) = asset {
                return asset1 == asset2
            }
        case .CreditAlphaNum12(let asset1):
            if case .CreditAlphaNum12(let asset2) = asset {
                return asset1 == asset2
            }
        }
        
        return false
    }
    

}

// Price in fractional representation
public struct Price: XDREncodableStruct {
    var n: Int32   // numerator
    var d: Int32   // denominator
}

// 'Thresholds' type is packed uint8_t values defined by these indexes
enum ThresholdIndexes {
    case MasterWeight
    case Low
    case Med
    case High
}

enum LedgerEntryType {
    case Account
    case TrustLine
    case Offer
    case Data
}

public struct Signer: XDREncodableStruct {
    public var key    : SignerKey
    public var weight : UInt32     // really only need 1 byte
}

// Flags set on issuer accounts
enum AccountFlags: UInt8 {
    case AuthRequired  = 0x1  // TrustLines are created with authorized set to "false" requiring the issuer to set it for each TrustLine
    case AuthRevocable = 0x2  // If set, the authorized flag in TrustLines can be cleared otherwise, authorization cannot be revoked
    case AuthImmutable = 0x4  // Once set, causes all AUTH_* flags to be read-only
}


/* AccountEntry
 Main entry representing a user in Stellar. All transactions are
 performed using an account.
 Other ledger entries created require an account.
 */

struct AccountEntry: XDREncodableStruct {
    var accountID     : AccountID      // master key for this account
    var balance       : Int64          // in stroops
    var seqNum        : SequenceNumber // last sequence number used for this account
    var numSubEntries : UInt32         // number of sub-entries this account has drives the reserve
    var inflationDest : AccountID      // Account to vote for during inflation
    var flags         : UInt32         // see AccountFlags
    var homeDomain    : String32       // can be used for reverse federation and memo lookup
    var thresholds    : Thresholds     // thresholds stores unsigned bytes: [weight of master|low|medium|high]
    var signers       : [Signer]       // Max 20. Possible signers for this account
    var ext           : Int            // reserved for future use
}

/* TrustLineEntry
 A trust line represents a specific trust relationship with
 a credit/issuer (limit, authorization)
 as well as the balance.
 */

enum TrustLineFlags: UInt8 {
    case Authorized = 1  // issuer has authorized account to perform transactions with its credit
}

struct TrustLineEntry: XDREncodableStruct {
    var accountID : AccountID  // account this trustline belongs to
    var asset     : Asset      // type of asset (with issuer)
    var balance   : Int64      // how much of this the: Asset user has. defines: Asset the unit for this
    var limit     : Int64      // balance cannot be above this
    var flags     : UInt32     // see TrustLineFlags
    var ext       : Reserved
}

enum OfferEntryFlags: UInt8 {
    case Passive = 1   // issuer has authorized account to perform transactions with its credit
}

/* OfferEntry
 An offer is the building block of the offer book, they are automatically
 claimed by payments when the price set by the owner is met.
 For example an Offer is selling 10A where 1A is priced at 1.5B
 */
struct OfferEntry: XDREncodableStruct {
    var sellerID : AccountID
    var offerID  : UInt64
    var selling  : Asset   // A
    var buying   : Asset   // B
    var amount   : Int64   // amount of A
    var price    : Price
    var flags    : UInt32  // see OfferEntryFlags
    var ext      : Reserved
    /* price for this offer:
     price of A in terms of B
     price=AmountB/AmountA=priceNumerator/priceDenominator
     price is after fees
     */
}

struct DataEntry: XDREncodableStruct {
    var accountID : AccountID // account this data belongs to
    var dataName  : String64
    var dataValue : DataValue?
    var ext       : Reserved
}

struct LedgerEntry: XDREncodableStruct {
    var  lastModifiedLedgerSeq: UInt32 // ledger the LedgerEntry was last changed
    enum data {
        case Account   (AccountEntry)
        case TrustLine (TrustLineEntry)
        case Offer     (OfferEntry)
        case Data      (DataEntry)
    }
    var ext: Reserved
}

// List of all envelope types used in the application those are prefixes used when building signatures for the respective envelopes
enum EnvelopeType: Int32 {
    case SCP  = 1
    case TX   = 2
    case AUTH = 3
}

// END
