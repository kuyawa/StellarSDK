//
//  StellarOverlay.swift
//  StellarSDK
//
//  Created by Laptop on 2/3/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Foundation

// Requires StellarLedger.swift

public enum ErrorCode {
    case Misc  // Unspecific error
    case Data  // Malformed data
    case Conf  // Misconfiguration error
    case Auth  // Authentication failure
    case Load  // System overloaded
}

public struct ErrorInfo {
    public let code: ErrorCode
    public let msg: String      // Max 100
}

public struct AuthCert {
    public let pubkey: Curve25519Public
    public let expiration: UInt64
    public let sig: Signature
}

public struct Hello {
    public let ledgerVersion: UInt32
    public let overlayVersion: UInt32
    public let overlayMinVersion: UInt32
    public let networkID: Hash
    public let versionStr: String  // Max 100
    public let listeningPort: Int
    public let peerID: NodeID
    public let cert: AuthCert
    public let nonce: UInt256
}

public struct Auth {
    public let unused: Int   // Empty message, just to confirm establishment of MAC keys.
}

public typealias IPv4 = Data // 4
public typealias IPv6 = Data // 16

public enum IPAddrType {
    case IPv4
    case IPv6
}

public enum IPAddress {
    case IPv4 (IPv4)
    case IPv6 (IPv6)
}

public struct PeerAddress {
    public let ip: IPAddress
    public let port: UInt32
    public let numFailures: UInt32
}

public enum MessageType: Int8 {
    case ERROR_MSG          =  0
    case AUTH               =  2
    case DONT_HAVE          =  3
    case GET_PEERS          =  4 // gets a list of peers this guy knows about
    case PEERS              =  5
    case GET_TX_SET         =  6 // gets a particular txset by hash
    case TX_SET             =  7
    case TRANSACTION        =  8 // pass on a tx you have heard about
    case GET_SCP_QUORUMSET  =  9
    case SCP_QUORUMSET      = 10
    case SCP_MESSAGE        = 11
    case GET_SCP_STATE      = 12
    case HELLO              = 13
}

public struct DontHave {
    public let type: MessageType
    public let reqHash: UInt256
}

//union StellarMessage switch (MessageType type) {
public enum StellarMessage {
    case ERROR_MSG         (Error)
    case HELLO             (Hello)
    case AUTH              (Auth)
    case DONT_HAVE         (DontHave)
    case GET_PEERS         (Void)
    case PEERS             (PeerAddress)
    case GET_TX_SET        (UInt256)
    case TX_SET            (TransactionSet)
    case TRANSACTION       (TransactionEnvelope)
    case GET_SCP_QUORUMSET (UInt256)
    case SCP_QUORUMSET     (SCPQuorumSet)
    case SCP_MESSAGE       (SCPEnvelope)
    case GET_SCP_STATE     (UInt32)        // ledger seq requested. If 0, requests the latest
}

public struct AuthenticatedMessage {
    let sequence: UInt64
    let message: StellarMessage
    let mac: HmacSha256Mac
}

// END
