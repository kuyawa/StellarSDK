//
//  TransactionBuilder.swift
//  StellarSDK
//
//  Created by Laptop on 2/4/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Foundation

class TransactionBuilder {
    var network: StellarSDK.Horizon.Network = .test
    var networkId: StellarSDK.Horizon.NetworkId = .test
    let baseFee = 100
    var source: PublicKey? = nil
    var sequence: SequenceNumber = 0
    var transaction: Transaction? = nil
    var lapse: TimeBounds = TimeBounds(minTime: 0, maxTime: 0)
    var memo: Memo = Memo.None()
    var operations: [Operation] = []
    var signatures: [Signature] = []
    var envelope: TransactionEnvelope?
    
    var txHash: String {
        if envelope != nil { return envelope!.xdr.base64 }
        return ""
    }
        
    init(_ source: PublicKey) {
        self.source = source
    }
    
    func setNetwork(_ net: StellarSDK.Horizon.Network) {
        network = net
    }
    
    func setSequence(_ seq: SequenceNumber) {
        sequence = SequenceNumber(seq+1)
    }
    
    func setSequence(_ seq: String?) {
        let seq = UInt64(seq ?? "0") ?? 0 // TODO: Guard
        sequence = SequenceNumber(seq+1)
    }
    
    func addOperation(_ op: Operation) {
        operations.append(op)
    }
    
    func addMemo(_ memo: Memo) {
        self.memo = memo
    }

    func addMemoText(_ memo: String?) {
        if let memo = memo, !memo.isEmpty {
            self.memo = Memo.Text(memo)
        }
    }
    
    @discardableResult
    func build() -> Transaction? {
        guard let source = source else { return nil }
        guard sequence > 0 else { return nil }
        let fee = UInt32(operations.count * baseFee)
        transaction  = Transaction(sourceAccount: source, fee: fee, seqNum: sequence, timeBounds: lapse, memo: memo, operations: operations, ext: 0)
        print("Transaction", transaction ?? "?")
        print("TXDR", transaction?.xdr.base64 ?? "?")
        return transaction
    }

    @discardableResult
    func sign(key: SecretKey) -> TransactionEnvelope? {
        // TODO: Guard all
        let hint      = DataFixed(key.data.bytes.suffix(4).data) // .prefix(upTo: 4))
        let netHash   = self.networkId.rawValue.dataUTF8!.sha256()
        let tagged    = TaggedTransaction.TX(transaction!)
        let payload   = TransactionSignaturePayload(networkId: DataFixed(netHash.data), taggedTransaction: tagged)
        let message   = payload.xdr.sha256()
        let signature = KeyPair.sign(message, key)
        let decorated = DecoratedSignature(hint: hint, signature: signature!)
        
        envelope = TransactionEnvelope(tx: transaction!, signatures: [decorated])
        print("\nEnvelope", envelope ?? "?")
        print("\nEnvXDR", envelope!.xdr.base64)
        return envelope
    }
    
    @discardableResult
    func signDebug(key: SecretKey) -> TransactionEnvelope? {
        // TODO: Guard all
        // Debugging
        print("\nPublicKey", key.data.bytes)
        let hint = DataFixed(key.data.bytes.suffix(4).data) // .prefix(upTo: 4))
        print("\nHint", hint.data.bytes)
        let netHash = self.networkId.rawValue.dataUTF8!.sha256()
        print("\nNethash", netHash.bytes)
        let tagged = TaggedTransaction.TX(transaction!)
        print("\nTagged", tagged)
        let payload = TransactionSignaturePayload(networkId: DataFixed(netHash.data), taggedTransaction: tagged)
        print("\nPayload", payload)
        let message = payload.xdr.sha256()
        print("\nMessage", message.bytes)
        let signature = KeyPair.sign(message, key)
        print("\nSignature", signature?.bytes ?? "?")
        let decorated = DecoratedSignature(hint: hint, signature: signature!)
        print("\nDecorated", decorated )
        envelope = TransactionEnvelope(tx: transaction!, signatures: [decorated])
        print("\nEnvelope", envelope ?? "?")
        print("\nEnvXDR", envelope!.xdr.base64)
        return envelope
    }
    
    func sign(keys: [PublicKey]) {
        // TODO: Loop signers
    }
    
    func submit(_ network: StellarSDK.Horizon.Network, callback: @escaping Callback) {
        // TODO: Submit and return response
    }
    
    
}
