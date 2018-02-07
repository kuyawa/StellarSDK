//
//  StellarSCP.swift
//  StellarSDK
//
//  Created by Laptop on 2/3/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Foundation

// Requires StellarTypes.swift

typealias Value = Data

struct SCPBallot: XDREncodableStruct {
    let counter: UInt32  // n
    let value: Value     // x
}

enum SCPStatementType {
    case Prepare
    case Confirm
    case Externalize
    case Nominate
}

struct SCPPrepare: XDREncodableStruct {
    let quorumSetHash: Hash       // D
    let ballot: SCPBallot         // b
    let prepared: SCPBallot       // p
    let preparedPrime: SCPBallot  // p'
    let nC: UInt32                // c.n
    let nH: UInt32                // h.n
}

struct SCPConfirm: XDREncodableStruct {
    let ballot: SCPBallot    // b
    let nPrepared: UInt32    // p.n
    let nCommit: UInt32      // c.n
    let nH: UInt32           // h.n
    let quorumSetHash: Hash  // D
}

struct SCPExternalize: XDREncodableStruct {
    let commit: SCPBallot               // c
    let nH: UInt32                      // h.n
    let commitQuorumSetHash: Hash       // D used before EXTERNALIZE
}

struct SCPNomination: XDREncodableStruct {
    let quorumSetHash: Hash  // D
    let votes: [Value]       // X
    let accepted: [Value]    // Y
}

enum SCPStatementData {
    case Prepare (SCPPrepare)
    case Confirm (SCPConfirm)
    case Externalize (SCPExternalize)
    case Nominate (SCPNomination)
}

struct SCPStatement: XDREncodableStruct {
    let nodeID: NodeID       // v
    let slotIndex: UInt64    // i
    let pledges: SCPStatementData
}

struct SCPEnvelope: XDREncodableStruct {
    let statement: SCPStatement
    let signature: Signature
}

// supports things like: A,B,C,(D,E,F),(G,H,(I,J,K,L))
// only allows 2 levels of nesting
// NOTE: Structs can not be nested, use class or hack
class SCPQuorumSet: XDREncodableStruct {
    var threshold: UInt32 = 0
    var validators: [PublicKey]?
    var innerSets: [SCPQuorumSet]? // Nested
}

// END
