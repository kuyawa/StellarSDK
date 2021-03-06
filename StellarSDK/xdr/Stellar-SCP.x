// Copyright 2015 Stellar Development Foundation and contributors. Licensed
// under the Apache License, Version 2.0. See the COPYING file at the root
// of this distribution or at http://www.apache.org/licenses/LICENSE-2.0

// include "xdr/Stellar-types.h"

//namespace stellar {

//typedef opaque Value<>;
typealis OpaqueValue Data

struct SCPBallot {
    var counter: UInt32  // n
    var value: OpaqueValue     // x
}

enum SCPStatementType: Int8 {
    case SCP_ST_PREPARE     = 0
    case SCP_ST_CONFIRM     = 1
    case SCP_ST_EXTERNALIZE = 2
    case SCP_ST_NOMINATE    = 3
}

struct SCPNomination {
    var Hash quorumSetHash // D
    var OpaqueValue votes<>      // X
    var OpaqueValue accepted<>   // Y
}

struct SCPStatement {
    NodeID nodeID    // v
    uint64 slotIndex // i

    union switch (SCPStatementType type)
    {
    case SCP_ST_PREPARE:
        struct
        {
            Hash quorumSetHash       // D
            SCPBallot ballot         // b
            SCPBallot* prepared      // p
            SCPBallot* preparedPrime // p'
            uint32 nC                // c.n
            uint32 nH                // h.n
        } prepare
    case SCP_ST_CONFIRM:
        struct
        {
            SCPBallot ballot   // b
            uint32 nPrepared   // p.n
            uint32 nCommit     // c.n
            uint32 nH          // h.n
            Hash quorumSetHash // D
        } confirm
    case SCP_ST_EXTERNALIZE:
        struct
        {
            SCPBallot commit         // c
            uint32 nH                // h.n
            Hash commitQuorumSetHash // D used before EXTERNALIZE
        } externalize
    case SCP_ST_NOMINATE:
        SCPNomination nominate
    }
    pledges
}

struct SCPEnvelope {
    SCPStatement statement
    Signature signature
}

// supports things like: A,B,C,(D,E,F),(G,H,(I,J,K,L))
// only allows 2 levels of nesting
struct SCPQuorumSet {
    uint32 threshold
    PublicKey validators<>
    SCPQuorumSet innerSets<>
}

// END