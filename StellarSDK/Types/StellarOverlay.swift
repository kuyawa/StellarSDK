//
//  StellarOverlay.swift
//  StellarSDK
//
//  Created by Laptop on 2/3/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Foundation

// Requires StellarLedger.swift

enum ErrorCode {
    case Misc  // Unspecific error
    case Data  // Malformed data
    case Conf  // Misconfiguration error
    case Auth  // Authentication failure
    case Load  // System overloaded
}

struct ErrorInfo: XDREncodableStruct {
    let code: ErrorCode
    let msg: [String]      // Max 100
}

struct AuthCert: XDREncodableStruct {
    let pubkey: Curve25519Public
    let expiration: UInt64
    let sig: Signature
}

struct Hello: XDREncodableStruct {
    let ledgerVersion: UInt32
    let overlayVersion: UInt32
    let overlayMinVersion: UInt32
    let networkID: Hash
    let versionStr: [String]  // Max 100
    let listeningPort: Int
    let peerID: NodeID
    let cert: AuthCert
    let nonce: UInt256
}

struct Auth: XDREncodableStruct {
    let unused: Int   // Empty message, just to confirm establishment of MAC keys.
}

typealias IPv4 = Data // Max 4
typealias IPv6 = Data // Max 16

enum IPAddressType {
    case IPv4
    case IPv6
}

enum IPAddress {
    case IPv4 (IPv4)
    case IPv6 (IPv6)
}

struct PeerAddress: XDREncodableStruct {
    let ip: IPAddress
    let port: UInt32
    let numFailures: UInt32
}

enum MessageType: Int8 {
    case ErrorMsg        =  0
    case Auth            =  2
    case DontHave        =  3
    case GetPeers        =  4  // gets a list of peers this guy knows about
    case Peers           =  5
    case GetTxSet        =  6  // gets a particular txset by hash
    case TxSet           =  7
    case Transaction     =  8  // pass on a tx you have heard about
    case GetScpQuorumset =  9
    case ScpQuorumset    = 10
    case ScpMessage      = 11
    case GetScpState     = 12
    case Hello           = 13
}

struct DontHave: XDREncodableStruct {
    let type: MessageType
    let reqHash: UInt256
}

typealias PeerAddresses = [PeerAddress]

//union StellarMessage switch (MessageType type) {
enum StellarMessage {
    case ErrorMsg        (ErrorInfo)
    case Hello           (Hello)
    case Auth            (Auth)
    case DontHave        (DontHave)
    case GetPeers        (Void)
    case Peers           (PeerAddresses)
    case GetTxSet        (UInt256)
    case TxSet           (TransactionSet)
    case Transaction     (TransactionEnvelope)
    case GetScpQuorumset (UInt256)
    case ScpQuorumset    (SCPQuorumSet)
    case ScpMessage      (SCPEnvelope)
    case GetScpState     (UInt32)        // ledger seq requested. If 0, requests the latest
}

struct AuthenticatedMessage: XDREncodableStruct {
    let sequence: UInt64
    let message: StellarMessage
    let mac: HmacSha256Mac
}

// END
