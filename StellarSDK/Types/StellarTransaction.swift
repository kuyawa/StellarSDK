//
//  StellarTransaction.swift
//  StellarSDK
//
//  Created by Laptop on 2/3/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Foundation

public struct DecoratedSignature {
    public var hint      : SignatureHint  // last 4 bytes of the public key, used as a hint
    public var signature : Signature      // actual signature
}

public enum OperationType {
    case CREATE_ACCOUNT
    case PAYMENT
    case PATH_PAYMENT
    case MANAGE_OFFER
    case CREATE_PASSIVE_OFFER
    case SET_OPTIONS
    case CHANGE_TRUST
    case ALLOW_TRUST
    case ACCOUNT_MERGE
    case INFLATION
    case MANAGE_DATA
}

/*  CreateAccount
 Creates and funds a new account with the specified starting balance.
 Threshold: med
 Result: CreateAccountResult
 */

public struct CreateAccountOp {
    public var destination     : AccountID // account to create
    public var startingBalance : Int64     // amount they end up with
}

/*  Payment
 Send an amount in specified asset to a destination account.
 Threshold: med
 Result: PaymentResult
 */

public struct PaymentOp {
    public var destination : AccountID   // recipient of the payment
    public var asset       : Asset       // what they end up with
    public var amount      : Int64       // amount they end up with
}

/*  PathPayment
 
 send an amount to a destination account through a path.
 (up to sendMax, sendAsset)
 (X0, Path[0]) .. (Xn, Path[n])
 (destAmount, destAsset)
 
 Threshold: med
 Result: PathPaymentResult
 */
public struct PathPaymentOp {
    public var sendAsset   : Asset     // asset we pay with
    public var sendMax     : Int64     // the maximum amount of sendAsset to send (excluding fees). The operation will fail if can't be met
    public var destination : AccountID // recipient of the payment
    public var destAsset   : Asset     // what they end up with
    public var destAmount  : Int64     // amount they end up with
    public var path        : [Asset]   // additional hops it must go through to get there
}

/* Creates, updates or deletes an offer
 Threshold: med
 Result: ManageOfferResult
 */
public struct ManageOfferOp {
    public var selling : Asset
    public var buying  : Asset
    public var amount  : Int64  // amount being sold. if set to 0, delete the offer
    public var price   : Price    // price of thing being sold in terms of what you are buying. 0=create a new offer, otherwise edit an existing offer
    public var offerID : UInt64
}

/* Creates an offer that doesn't take offers of the same price
 Threshold: med
 Result: CreatePassiveOfferResult
 */
public struct CreatePassiveOfferOp {
    public var selling : Asset     // A
    public var buying  : Asset     // B
    public var amount  : Int64     // amount taker gets. if set to 0, delete the offer
    public var price   : Price     // cost of A in terms of B
}

/* Set Account Options
 updates "AccountEntry" fields.
 note: updating thresholds or signers requires high threshold
 Threshold: med or high
 Result: SetOptionsResult
 */
public struct SetOptionsOp {
    public var inflationDest : AccountID   // sets the inflation destination
    public var clearFlags    : UInt32      // which flags to clear
    public var setFlags      : UInt32      // which flags to set
    public var masterWeight  : UInt32      // weight of the master account
    public var lowThreshold  : UInt32
    public var medThreshold  : UInt32
    public var highThreshold : UInt32
    public var homeDomain    : String      // sets the home domain
    public var signer        : Signer      // Add, update or remove a signer for the account. Signer is deleted if the weight is 0
}

/* Creates, updates or deletes a trust line
 Threshold: med
 Result: ChangeTrustResult
 */
public struct ChangeTrustOp {
    public var line  : Asset      // if limit is set to 0, deletes the trust line
    public var limit : Int64
}

/* Updates the "authorized" flag of an existing trust line
 this is called by the issuer of the related asset.
 note that authorize can only be set (and not cleared) if
 the issuer account does not have the AUTH_REVOCABLE_FLAG set
 Threshold: low
 Result: AllowTrustResult
 */
public struct AllowTrustOp {
    public var trustor : AccountID
    //public var asset : Asset
    
    public enum asset {
        // ASSET_TYPE_NATIVE is not allowed
        case CREDIT_ALPHANUM4  (AssetCode4)
        case CREDIT_ALPHANUM12 (AssetCode12)
        // add other asset types here in the future
    }
    
    public var authorize: Bool
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
 Adds, Updates, or Deletes a key value pair associated with a particular
	account.
 Threshold: med
 Result: ManageDataResult
 */
public struct ManageDataOp {
    public var dataName  : String
    public var dataValue : DataValue   // set to null to clear
}

/* An operation is the lowest unit of work that a transaction does */
public struct Operation {
    public var sourceAccount : AccountID       // sourceAccount is the account used to run the operation, if not set, the runtime defaults to "sourceAccount" specified at the transaction level
    public var body          : OperationBody
    
    public enum OperationBody {
        case CREATE_ACCOUNT       (CreateAccountOp)
        case PAYMENT              (PaymentOp)
        case PATH_PAYMENT         (PathPaymentOp)
        case MANAGE_OFFER         (ManageOfferOp)
        case CREATE_PASSIVE_OFFER (CreatePassiveOfferOp)
        case SET_OPTIONS          (SetOptionsOp)
        case CHANGE_TRUST         (ChangeTrustOp)
        case ALLOW_TRUST          (AllowTrustOp)
        case ACCOUNT_MERGE        (AccountID)
        case INFLATION            (Void)
        case MANAGE_DATA          (ManageDataOp)
    }
}

public enum MemoType {
    case MEMO_NONE
    case MEMO_TEXT
    case MEMO_ID
    case MEMO_HASH
    case MEMO_RETURN
}

public enum Memo {
    case MEMO_NONE   (Void)
    case MEMO_TEXT   (String)   // Max 28
    case MEMO_ID     (UInt64)
    case MEMO_HASH   (Hash)     // the hash of what to pull from the content server
    case MEMO_RETURN (Hash)     // the hash of the tx you are rejecting
}

public struct TimeBounds {
    public var minTime: UInt64
    public var maxTime: UInt64 // 0 here means no maxTime
}

/* a transaction is a container for a set of operations
 - is executed by an account
 - fees are collected from the account
 - operations are executed in order as one ACID transaction
 either all operations are applied or none are
 if any returns a failing code
 */

public struct Transaction {
    public var sourceAccount : AccountID      // account used to run the transaction
    public var fee           : UInt32         // the fee the sourceAccount will pay
    public var seqNum        : SequenceNumber // sequence number to consume in the account
    public var timeBounds    : TimeBounds     // validity range (inclusive) for the last ledger close time
    public var memo          : Memo
    public var operations    : Operation      // Max 100
    public var ext           : Reserved
}

public struct TransactionSignaturePayload {
    public var  networkId: Hash
    public enum taggedTransaction {
        case ENVELOPE_TYPE_TX (Transaction) /* All other values of type are invalid */
    }
}

/* A TransactionEnvelope wraps a transaction with signatures. */
public struct TransactionEnvelope {
    public var tx: Transaction
    public var signatures: DecoratedSignature  // Each decorated signature is a signature over the SHA256 hash of a TransactionSignaturePayload
}


// END
