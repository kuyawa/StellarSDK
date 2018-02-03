//
//  StellarLedgerEntries.swift
//  StellarSDK
//
//  Created by Laptop on 2/3/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Foundation

public typealias AccountID      = String  // Max 56
public typealias Thresholds     = Data    // Max  4
public typealias String32       = String  // Max 32
public typealias String64       = String  // Max 64
public typealias DataValue      = Data    // Max 64
public typealias SequenceNumber = UInt64
public typealias AssetCode4     = String  // Max  4
public typealias AssetCode12    = String  // Max 12
public typealias Reserved       = Int     // Reserved for future use

// CONSTANTS

let MASK_ACCOUNT_FLAGS    = 0x7  // mask for all valid flags
let MASK_TRUSTLINE_FLAGS  = 1    // mask for all trustline flags
let MASK_OFFERENTRY_FLAGS = 1    // Mask for OfferEntry flags


public enum AssetType {
    case Native
    case CreditAlphaNum4
    case CreditAlphaNum12
}

public struct Asset {
    public var type      : AssetType
    public var assetCode : String
    public var issuer    : AccountID
}

// Price in fractional representation
public struct Price {
    public var n: Int32   // numerator
    public var d: Int32   // denominator
}

// 'Thresholds' type is packed uint8_t values defined by these indexes
public enum ThresholdIndexes {
    case MasterWeight
    case Low
    case Med
    case High
}

public enum LedgerEntryType {
    case Account
    case TrustLine
    case Offer
    case Data
}

public struct Signer {
    public var key    : SignerKey
    public var weight : UInt32     // really only need 1 byte
}

// Flags set on issuer accounts
public enum AccountFlags: UInt8 {
    case AuthRequired  = 0x1  // TrustLines are created with authorized set to "false" requiring the issuer to set it for each TrustLine
    case AuthRevocable = 0x2  // If set, the authorized flag in TrustLines can be cleared otherwise, authorization cannot be revoked
    case AuthImmutable = 0x4  // Once set, causes all AUTH_* flags to be read-only
}


/* AccountEntry
    Main entry representing a user in Stellar. All transactions are
    performed using an account.
    Other ledger entries created require an account.
*/

public struct AccountEntry {
    public var accountID     : AccountID      // master public key for this account
    public var balance       : Int64          // in stroops
    public var seqNum        : SequenceNumber // last sequence number used for this account
    public var numSubEntries : UInt32         // number of sub-entries this account has drives the reserve
    public var inflationDest : AccountID      // Account to vote for during inflation
    public var flags         : UInt32         // see AccountFlags
    public var homeDomain    : String32       // can be used for reverse federation and memo lookup
    public var thresholds    : Thresholds     // thresholds stores unsigned bytes: [weight of master|low|medium|high]
    public var signers       : Signer         // Max 20. Possible signers for this account
    public var ext           : Int            // reserved for future use
}

/* TrustLineEntry
    A trust line represents a specific trust relationship with
    a credit/issuer (limit, authorization)
    as well as the balance.
*/

public enum TrustLineFlags: UInt8 {
    case Authorized = 1  // issuer has authorized account to perform transactions with its credit
}

public struct TrustLineEntry {
    public var accountID : AccountID  // account this trustline belongs to
    public var asset     : Asset      // type of asset (with issuer)
    public var balance   : Int64      // how much of this the: Asset user has. defines: Asset the unit for this
    public var limit     : Int64      // balance cannot be above this
    public var flags     : UInt32     // see TrustLineFlags
    public var ext       : Reserved
}

public enum OfferEntryFlags: UInt8 {
    case Passive = 1   // issuer has authorized account to perform transactions with its credit
}

/* OfferEntry
    An offer is the building block of the offer book, they are automatically
    claimed by payments when the price set by the owner is met.
    For example an Offer is selling 10A where 1A is priced at 1.5B
*/
public struct OfferEntry {
    public var sellerID : AccountID
    public var offerID  : UInt64
    public var selling  : Asset   // A
    public var buying   : Asset   // B
    public var amount   : Int64   // amount of A
    public var price    : Price
    public var flags    : UInt32  // see OfferEntryFlags
    public var ext      : Reserved
    /* price for this offer:
     price of A in terms of B
     price=AmountB/AmountA=priceNumerator/priceDenominator
     price is after fees
     */
}

public struct DataEntry {
    public var accountID : AccountID // account this data belongs to
    public var dataName  : String64
    public var dataValue : DataValue
    public var ext       : Reserved
}


public struct LedgerEntry {
    public var  lastModifiedLedgerSeq: UInt32 // ledger the LedgerEntry was last changed
    public enum data {
      case Account   (AccountEntry)
      case TrustLine (TrustLineEntry)
      case Offer     (OfferEntry)
      case Data      (DataEntry)
    }
    public var ext: Reserved
}

// List of all envelope types used in the application those are prefixes used when building signatures for the respective envelopes
public enum EnvelopeType: UInt8 {
    case SCP  = 1
    case TX   = 2
    case AUTH = 3
}

// END
