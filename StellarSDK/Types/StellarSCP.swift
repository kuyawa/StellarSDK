//
//  StellarSCP.swift
//  StellarSDK
//
//  Created by Laptop on 2/3/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Foundation

// Requires StellarTypes.swift

public typealias Value = Data

public struct SCPBallot {
    public let counter: UInt32  // n
    public let value: Value     // x
}

public enum SCPStatementType {
    case Prepare
    case Confirm
    case Externalize
    case Nominate
}

public struct SCPPrepare {
    public let quorumSetHash: Hash       // D
    public let ballot: SCPBallot         // b
    public let prepared: SCPBallot       // p
    public let preparedPrime: SCPBallot  // p'
    public let nC: UInt32                // c.n
    public let nH: UInt32                // h.n
}

public struct SCPConfirm {
    public let ballot: SCPBallot    // b
    public let nPrepared: UInt32    // p.n
    public let nCommit: UInt32      // c.n
    public let nH: UInt32           // h.n
    public let quorumSetHash: Hash  // D
}

public struct SCPExternalize {
    public let commit: SCPBallot               // c
    public let nH: UInt32                      // h.n
    public let commitQuorumSetHash: Hash       // D used before EXTERNALIZE
}

public struct SCPNomination {
    public let quorumSetHash: Hash  // D
    public let votes: Value         // X
    public let accepted: Value      // Y
}

public enum SCPStatementData {
    case Prepare (SCPPrepare)
    case Confirm (SCPConfirm)
    case Externalize (SCPExternalize)
    case Nominate (SCPNomination)
}

public struct SCPStatement {
    public let nodeID: NodeID       // v
    public let slotIndex: UInt64    // i
    public let pledges: SCPStatementData
}

public struct SCPEnvelope {
    public let statement: SCPStatement
    public let signature: Signature
}

// supports things like: A,B,C,(D,E,F),(G,H,(I,J,K,L))
// only allows 2 levels of nesting
// NOTE: Structs can not be nested, use class or hack
public class SCPQuorumSet {
    public var threshold: UInt32 = 0
    public var validators: PublicKey?
    public var innerSets: SCPQuorumSet? // Nested
}

// END
