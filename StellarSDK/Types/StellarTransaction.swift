//
//  StellarTransaction.swift
//  StellarSDK
//
//  Created by Laptop on 2/3/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Foundation

enum OperationType: Int32 {
    case CreateAccount = 0
    case Payment
    case PathPayment
    case ManageOffer
    case CreatePassiveOffer
    case SetOptions
    case ChangeTrust
    case AllowTrust
    case AccountMerge
    case Inflation
    case ManageData
}

/* CreateAccount
   Creates and funds a new account with the specified starting balance.
   Threshold: med
   Result: CreateAccountResult
 */

struct CreateAccountOp: XDREncodableStruct {
    var destination     : AccountID // account to create
    var startingBalance : Int64     // amount they end up with
}

/* Payment
   Send an amount in specified asset to a destination account.
   Threshold: med
   Result: PaymentResult
 */

struct PaymentOp: XDREncodableStruct {
    var destination : AccountID   // recipient of the payment
    var asset       : Asset       // what they end up with
    var amount      : Int64       // amount they end up with
}

/* PathPayment
   send an amount to a destination account through a path.
   (up to sendMax, sendAsset)
   (X0, Path[0]) .. (Xn, Path[n])
   (destAmount, destAsset)
 
   Threshold: med
   Result: PathPaymentResult
 */
struct PathPaymentOp: XDREncodableStruct {
    var sendAsset   : Asset     // asset we pay with
    var sendMax     : Int64     // the maximum amount of sendAsset to send (excluding fees). The operation will fail if can't be met
    var destination : AccountID // recipient of the payment
    var destAsset   : Asset     // what they end up with
    var destAmount  : Int64     // amount they end up with
    var path        : [Asset]   // Max 5. Additional hops it must go through to get there
}

/* Creates, updates or deletes an offer
   Threshold: med
   Result: ManageOfferResult
 */
struct ManageOfferOp: XDREncodableStruct {
    var selling : Asset
    var buying  : Asset
    var amount  : Int64  // amount being sold. if set to 0, delete the offer
    var price   : Price    // price of thing being sold in terms of what you are buying. 0=create a new offer, otherwise edit an existing offer
    var offerID : UInt64
}

/* Creates an offer that doesn't take offers of the same price
   Threshold: med
   Result: CreatePassiveOfferResult
 */
struct CreatePassiveOfferOp: XDREncodableStruct {
    var selling : Asset     // A
    var buying  : Asset     // B
    var amount  : Int64     // amount taker gets. if set to 0, delete the offer
    var price   : Price     // cost of A in terms of B
}

/* Set Account Options
   updates "AccountEntry" fields.
   note: updating thresholds or signers requires high threshold
   Threshold: med or high
   Result: SetOptionsResult
 */
struct SetOptionsOp: XDREncodableStruct {
    var inflationDest : AccountID? = nil   // sets the inflation destination
    var clearFlags    : UInt32? = nil      // which flags to clear
    var setFlags      : UInt32? = nil      // which flags to set
    var masterWeight  : UInt32? = nil      // weight of the master account
    var lowThreshold  : UInt32? = nil
    var medThreshold  : UInt32? = nil
    var highThreshold : UInt32? = nil
    var homeDomain    : String? = nil      // sets the home domain
    var signer        : Signer? = nil      // Add, update or remove a signer for the account. Signer is deleted if the weight is 0
    
    init(inflationDest: AccountID?) {
        self.inflationDest = inflationDest
    }
    
    init(clearFlags: UInt32, setFlags: UInt32) {
        self.clearFlags = clearFlags
        self.setFlags   = setFlags
    }
    
    init(clearFlags: UInt32) {
        self.clearFlags = clearFlags
    }
    
    init(setFlags: UInt32) {
        self.setFlags = setFlags
    }
    
    init(masterWeight: UInt32) {
        self.masterWeight = masterWeight
    }
    
    init(low: UInt32, med: UInt32, high: UInt32) {
        self.lowThreshold  = low
        self.medThreshold  = med
        self.highThreshold = high
    }

    init(homeDomain: String) {
        self.homeDomain = homeDomain
    }
    
    init(signer: Signer) {
        self.signer = signer
    }
    
    init() {
        //
    }

}

/* Creates, updates or deletes a trust line
   Threshold: med
   Result: ChangeTrustResult
 */
struct ChangeTrustOp: XDREncodableStruct {
    var line  : Asset
    var limit : Int64   // if limit is set to 0, deletes the trust line, if set to Int.max sets no limit
}

/* Updates the "authorized" flag of an existing trust line
   this is called by the issuer of the related asset.
   note that authorize can only be set (and not cleared) if
   the issuer account does not have the AUTH_REVOCABLE_FLAG set
   Threshold: low
   Result: AllowTrustResult
 */
struct AllowTrustOp: XDREncodableStruct {
    var trustor : AccountID
    //var asset : Asset
    
    enum asset {
        // ASSET_TYPE_NATIVE is not allowed
        case CreditAlphaNum4  (AssetCode4)
        case CreditAlphaNum12 (AssetCode12)
        // add other asset types here in the future
    }
    
    var authorize: Bool
}

/* Inflation
   Runs inflation
   Threshold: low
   Result: InflationResult
 */

/* AccountMerge
   Transfers native balance to destination account.
   Threshold: high
   Result : AccountMergeResult
 */

/* ManageData
   Adds, Updates, or Deletes a key value pair associated with a particular account.
   Threshold: med
   Result: ManageDataResult
 */
struct ManageDataOp: XDREncodableStruct {
    var dataName  : String
    var dataValue : String?   // set to null to clear
}


enum OperationBody: XDREncodable {
    case CreateAccount      (CreateAccountOp)
    case Payment            (PaymentOp)
    case PathPayment        (PathPaymentOp)
    case ManageOffer        (ManageOfferOp)
    case CreatePassiveOffer (CreatePassiveOfferOp)
    case SetOptions         (SetOptionsOp)
    case ChangeTrust        (ChangeTrustOp)
    case AllowTrust         (AllowTrustOp)
    case AccountMerge       (AccountID)  // AccountID not Op
    case Inflation          (Void)
    case ManageData         (ManageDataOp)
    
    var discriminant: Int32 {
        switch self {
        case .CreateAccount      : return OperationType.CreateAccount.rawValue
        case .Payment            : return OperationType.Payment.rawValue
        case .PathPayment        : return OperationType.PathPayment.rawValue
        case .ManageOffer        : return OperationType.ManageOffer.rawValue
        case .CreatePassiveOffer : return OperationType.CreatePassiveOffer.rawValue
        case .SetOptions         : return OperationType.SetOptions.rawValue
        case .ChangeTrust        : return OperationType.ChangeTrust.rawValue
        case .AllowTrust         : return OperationType.AllowTrust.rawValue
        case .AccountMerge       : return OperationType.AccountMerge.rawValue
        case .Inflation          : return OperationType.Inflation.rawValue
        case .ManageData         : return OperationType.ManageData.rawValue
        }
    }
    
    func toXDR(count: Int32 = 0) -> Data {
        var xdr = discriminant.xdr
        
        switch self {
        case .CreateAccount(let op)      : xdr.append(op.xdr)
        case .Payment(let op)            : xdr.append(op.xdr)
        case .PathPayment(let op)        : xdr.append(op.xdr)
        case .ManageOffer(let op)        : xdr.append(op.xdr)
        case .CreatePassiveOffer(let op) : xdr.append(op.xdr)
        case .SetOptions(let op)         : xdr.append(op.xdr)
        case .ChangeTrust(let op)        : xdr.append(op.xdr)
        case .AllowTrust(let op)         : xdr.append(op.xdr)
        case .AccountMerge(let op)       : xdr.append(op.xdr)
        case .Inflation                  : break //xdr.append(op.xdr)
        case .ManageData(let op)         : xdr.append(op.xdr)
        }
        
        return xdr
    }
}

/* An operation is the lowest unit of work that a transaction does */

struct Operation: XDREncodableStruct {
    var sourceAccount: AccountID?       // sourceAccount is the account used to run the operation, if not set, the runtime defaults to "sourceAccount" specified at the transaction level
    var body: OperationBody
}

typealias Operations = [Operation]

enum MemoType: Int32 {
    case None = 0
    case Text
    case Id
    case Hash
    case Return
}

public enum Memo: XDREncodable {
    case None   (Void)
    case Text   (String)   // Max 28
    case Id     (UInt64)
    case Hash   (Hash)     // the hash of what to pull from the content server
    case Return (Hash)     // the hash of the tx you are rejecting
    
    var discriminant: Int32 {
        switch self {
        case .None:   return MemoType.None.rawValue
        case .Text:   return MemoType.Text.rawValue
        case .Id:     return MemoType.Id.rawValue
        case .Hash:   return MemoType.Hash.rawValue
        case .Return: return MemoType.Return.rawValue
        }
    }
    
    public func toXDR(count: Int32 = 0) -> Data {
        var xdr = discriminant.xdr
        
        switch self {
        case .None: break
        case .Text   (let str) : xdr.append(str.xdr)  // TODO: Trim up to 28 chars?
        case .Id     (let id)  : xdr.append(  id.xdr)
        case .Hash   (let hash): xdr.append(hash.xdr)
        case .Return (let hash): xdr.append(hash.xdr)
        }

        return xdr
    }

    public var text: String {
        switch self {
        case .None:            return ""
        case .Text(let str):   return str
        case .Id(let id):      return id.description
        case .Hash(let hash):  return hash.data.base64
        case .Return(let ret): return ret.data.base64
        }
    }
}

struct TimeBounds: XDREncodableStruct {
    var minTime: UInt64
    var maxTime: UInt64 // 0 here means no maxTime
}

/* a transaction is a container for a set of operations
 - is executed by an account
 - fees are collected from the account
 - operations are executed in order as one ACID transaction
   either all operations are applied or none are
   if any returns a failing code
 */

struct Transaction: XDREncodableStruct {
    var sourceAccount : AccountID      // account used to run the transaction
    var fee           : UInt32         // the fee the sourceAccount will pay
    var seqNum        : SequenceNumber // sequence number to consume in the account
    var timeBounds    : TimeBounds?    // validity range (inclusive) for the last ledger close time
    var memo          : Memo
    var operations    : [Operation]    // Max 100
    var ext           : Reserved = 0
}

enum TaggedTransaction: XDREncodable {
    case TX (Transaction)  // All other values of type are invalid
    
    var discriminant: Int32 {
        switch self {
        case .TX: return EnvelopeType.TX.rawValue
        }
    }
    
    func toXDR(count: Int32 = 0) -> Data {
        var xdr = discriminant.xdr
        
        switch self {
        case .TX (let tx): xdr.append(tx.xdr)
        }
        
        return xdr
    }

}

struct TransactionSignaturePayload: XDREncodableStruct {
    var networkId: Hash
    var taggedTransaction: TaggedTransaction
}

struct DecoratedSignature: XDREncodableStruct {
    var hint: SignatureHint   // last 4 bytes of the key, used as a hint
    var signature: Signature  // actual signature
}

/* A TransactionEnvelope wraps a transaction with signatures. */
struct TransactionEnvelope: XDREncodableStruct {
    var tx: Transaction
    var signatures: [DecoratedSignature]  // Max 20. Each decorated signature is a signature over the SHA256 hash of a TransactionSignaturePayload
}


// END
