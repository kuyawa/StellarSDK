//
//  StellarLedger.swift
//  StellarSDK
//
//  Created by Laptop on 2/3/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Foundation

// Requires StellarSCP.swift
// Requires StellarTransaction.swift


public typealias UpgradeType = Data  // Max 128
public typealias LedgerEntryChanges = [LedgerEntryChange]

/* StellarValue is the value used by SCP to reach consensus on a given ledger */
public struct StellarValue {
    let txSetHash: Hash   // transaction set to apply to previous ledger
    let closeTime: UInt64 // network close time
    
    // upgrades to apply to the previous ledger (usually empty)
    // this is a vector of encoded 'LedgerUpgrade' so that nodes can drop
    // unknown steps during consensus if needed.
    // see notes below on 'LedgerUpgrade' for more detail
    // max size is dictated by number of upgrade types (+ room for future)
    let upgrades: [UpgradeType]  // Max 6
    
    // reserved for future use
    let ext: Reserved
}

/* The LedgerHeader is the highest level public structure representing the
 * state of a ledger, cryptographically linked to previous ledgers.
 */
public struct LedgerHeader {
    let ledgerVersion: UInt32    // the protocol version of the ledger
    let previousLedgerHash: Hash // hash of the previous ledger header
    let scpValue: StellarValue   // what consensus agreed to
    let txSetResultHash: Hash    // the TransactionResultSet that led to this ledger
    let bucketListHash: Hash     // hash of the ledger state
    let ledgerSeq: UInt32        // sequence number of this ledger
    let totalCoins: Int64        // total number of stroops in existence. 10,000,000 stroops in 1 XLM
    let feePool: Int64           // fees burned since last inflation run
    let inflationSeq: UInt32     // inflation sequence number
    let idPool: UInt64           // last used global ID, used for generating objects
    let baseFee: UInt32          // base fee per operation in stroops
    let baseReserve: UInt32      // account base reserve in stroops
    let maxTxSetSize: UInt32     // maximum size a transaction set can be
    let skipList: Hash           // Max 4. Hashes of ledgers in the past. allows you to jump back
    // in time without walking the chain back ledger by ledger
    // each slot contains the oldest ledger that is mod of
    // either 50  5000  50000 or 500000 depending on index
    // skipList[0] mod(50), skipList[1] mod(5000), etc
    
    let ext: Reserved
}

/* Ledger upgrades
 note that the `upgrades` field from StellarValue is normalized such that
 it only contains one entry per LedgerUpgradeType, and entries are sorted
 in ascending order
 */
public enum LedgerUpgradeType: UInt8 {
    case Version      = 1
    case BaseFee      = 2
    case MaxTxSetSize = 3
    case BaseReserve  = 4
}

public enum LedgerUpgrade {
    case Version      (UInt32)  // update ledgerVersion
    case BaseFee      (UInt32)  // update baseFee
    case MaxTxSetSize (UInt32)  // update maxTxSetSize
    case BaseReserve  (UInt32)  // update baseReserve
}

/* Entries used to define the bucket list */

public struct LedgerKeyAccount {
    let accountID: AccountID
}

public struct LedgerKeyTrustLine {
    let accountID: AccountID
    let asset: Asset
}

public struct LedgerKeyOffer {
    let sellerID: AccountID
    let offerID: UInt64
}

public struct LedgerKeyData {
    let accountID: AccountID
    let dataName: String64
}

public enum LedgerKey {
    case Account   (LedgerKeyAccount)
    case TrustLine (LedgerKeyTrustLine)
    case Offer     (LedgerKeyOffer)
    case Data      (LedgerKeyData)
}

public enum BucketEntryType {
    case LiveEntry
    case DeadEntry
}

public enum BucketEntry {
    case LiveEntry (LedgerEntry)
    case DeadEntry (LedgerKey)
}

// Transaction sets are the unit used by SCP to decide on transitions between ledgers
public struct TransactionSet {
    let previousLedgerHash: Hash
    let txs: [TransactionEnvelope]
}

public struct TransactionResultPair {
    let transactionHash: Hash
    let result: TransactionResult // result for the transaction
}

// TransactionResultSet is used to recover results between ledgers
public struct TransactionResultSet {
    let results: [TransactionResultPair]
}

// Entries below are used in the historical subsystem

public struct TransactionHistoryEntry {
    let ledgerSeq: UInt32
    let txSet: TransactionSet
    let ext: Reserved
}

public struct TransactionHistoryResultEntry {
    let ledgerSeq: UInt32
    let txResultSet: TransactionResultSet
    let ext: Reserved
}

public struct LedgerHeaderHistoryEntry {
    let hash: Hash
    let header: LedgerHeader
    let ext: Reserved
}

// historical SCP messages

public struct LedgerSCPMessages {
    let ledgerSeq: UInt32
    let messages: [SCPEnvelope]
}

// note: ledgerMessages may refer to any quorumSets encountered
// in the file so far, not just the one from this entry
public struct SCPHistoryEntryV0 {
    let quorumSets: [SCPQuorumSet]          // additional quorum sets used by ledgerMessages
    let ledgerMessages: LedgerSCPMessages
}

// SCP history file is an array of these
public enum SCPHistoryEntry {
    case V0 (SCPHistoryEntryV0)
}

// represents the meta in the transaction table history

// STATE is emitted every time a ledger entry is modified/deleted
// and the entry was not already modified in the current ledger

public enum LedgerEntryChangeType {
    case Created  // entry was added to the ledger
    case Updated  // entry was modified in the ledger
    case Removed  // entry was removed from the ledger
    case State    // value of the entry
}

public enum LedgerEntryChange {
    case Created (LedgerEntry)
    case Updated (LedgerEntry)
    case Removed (LedgerKey)
    case State   (LedgerEntry)
}

public struct OperationMeta {
    let changes: LedgerEntryChanges
}

public struct TransactionMeta {
    let operations: [OperationMeta]
}

// END
