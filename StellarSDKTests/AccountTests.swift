//
//  Account.swift
//  StellarSDK
//
//  Created by Laptop on 1/28/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import XCTest
@testable import StellarSDK
@testable import CryptoSwift


let testAddress = "GAMMLP3BRHWAIRNNSAKD7UXWFITNI3YODZV4CFQ7FSILIL7E6SKQWTTX"
let testSecret  = "SDS54DFAILKMUWZOVIPN4Q4SSE33T4FEJP2MLOBEBNGFKINO46ZXXZDN"
let testDestin  = "GAJ54B2Q73XHXMKLGUWNUQL5XZLIS3ML7MHRNICYBWBLQQDVESJJNNMJ"

class AccountTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here.
    }
    
    override func tearDown() {
        // Put teardown code here.
        super.tearDown()
        print()
    }

    func testAccountRandom() {
        print("\n---- \(#function)\n")
        
        let account = StellarSDK.Account.random()
        
        print("Public key:", account.publicKey)
        print("Secret key:", account.secretKey)
        
        XCTAssertNotNil(account, "Error generating random account")
    }
    
    func testAccountFromSecret() {
        print("\n---- \(#function)\n")
        
        let account1 = StellarSDK.Account.random()
        let account2 = StellarSDK.Account.fromSecret(account1.secretKey)!
        
        print("#1 Public key:", account1.publicKey)
        print("#1 Secret key:", account1.secretKey)
        print()
        print("#2 Public key:", account2.publicKey)
        print("#2 Secret key:", account2.secretKey)
        
        XCTAssertEqual(account1.publicKey, account2.publicKey, "Error generating account from secret")
    }
    
    func testAccountInfo() {
        print("\n---- \(#function)\n")
        
        let expect    = expectation(description: "ACCOUNT INFO")
        let publicKey = testAddress
        let account   = StellarSDK.Account(publicKey, .test)
        
        account.getInfo { info in
            print("RAW:", info.raw ?? "?")
            print("----")
            print("Id"           , info.id            ?? "?")
            print("info id"      , info.accountId     ?? "?")
            print("Paging token" , info.pagingToken   ?? "?")
            print("Sequence"     , info.sequence      ?? "?")
            print("SubentryCount", info.subentryCount)
            print("Thresholds"   , info.thresholds    ?? "?")
            print("Flags"        , info.flags         ?? "?")
            print("Balances"     , info.balances)
            print("Signers"      , info.signers)
            print("Data"         , info.data)
            print("Links"        , info.links         ?? "?")
            XCTAssertNil(info.error, "Error in server request")
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 20){ error in
            if let error = error { print("Timeout Error: \(error.localizedDescription)") }
        }
    }

    func testAccountBalance() {
        print("\n---- \(#function)\n")
        
        let expect    = expectation(description: "ACCOUNT BALANCE")
        let publicKey = testAddress
        let account   = StellarSDK.Account(publicKey, .test)
        
        account.getBalance { balance in
            //if balance < 0 { print("XLM Balance not found") }
            print("Balance", balance, "XLM")
            XCTAssertGreaterThan(balance, -1, "Balance not found")
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 20){ error in
            if let error = error { print("Timeout Error: \(error.localizedDescription)") }
        }
    }

    func testAccountBalanceAsset() {
        print("\n---- \(#function)\n")
        
        let expect    = expectation(description: "ACCOUNT BALANCE")
        let publicKey = testAddress
        let account   = StellarSDK.Account(publicKey, .test)
        
        account.getBalance(asset: "USD") { balance in
            if balance < 0 { print("USD Balance not found") }
            print("Balance", balance, "USD")
            XCTAssertGreaterThan(balance, 0, "USD Balance not found")
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 20){ error in
            if let error = error { print("Timeout Error: \(error.localizedDescription)") }
        }
    }
    
    func testAccountBalances() {
        print("\n---- \(#function)\n")
        
        let expect    = expectation(description: "ACCOUNT BALANCE")
        let publicKey = testAddress
        let account   = StellarSDK.Account(publicKey, .test)
        
        account.getBalances { balances in
            print(balances.count, "Balances")
            for item in balances {
                print("Balance:", item.balance, item.assetCode)
            }
            XCTAssertGreaterThan(balances.count, 0, "Balances not found")
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 20){ error in
            if let error = error { print("Timeout Error: \(error.localizedDescription)") }
        }
    }
    
    func testAccountOperations() {
        print("\n---- \(#function)\n")
        
        let expect    = expectation(description: "ACCOUNT OPERATIONS")
        let publicKey = testAddress
        let account   = StellarSDK.Account(publicKey, .test)
        
        account.getOperations { operations in
            print("RAW:", operations.raw ?? "?")
            print("----")
            print("Records", operations.records.count)
            for operation in operations.records {
                print("Operation:", operation.typeInt, operation.from ?? "?", operation.amount ?? "?")
            }
            XCTAssertNil(operations.error, "Error in server request")
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 20){ error in
            if let error = error { print("Error: \(error.localizedDescription)") }
        }
    }
    
    func testAccountPayments() {
        print("\n---- \(#function)\n")
        
        let expect    = expectation(description: "ACCOUNT PAYMENTS")
        let publicKey = testAddress
        let account   = StellarSDK.Account(publicKey, .test)
        
        account.getPayments { payments in
            print("RAW:", payments.raw ?? "?")
            print("----")
            print("Records", payments.records.count)
            for payment in payments.records {
                print("Payment:", payment.typeInt, payment.from!, payment.to!, payment.amount!)
            }
            XCTAssertNil(payments.error, "Error in server request")
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 20){ error in
            if let error = error { print("Error: \(error.localizedDescription)") }
        }
    }
    
    func testAccountTransactions() {
        print("\n---- \(#function)\n")
        
        let expect    = expectation(description: "ACCOUNT TRANSACTIONS")
        let publicKey = testAddress
        let account   = StellarSDK.Account(publicKey, .test)
        
        account.getTransactions { transactions in
            print("RAW:", transactions.raw ?? "?")
            print("----")
            print("Records", transactions.records.count)
            XCTAssertNil(transactions.error, "Error in server request")
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 20){ error in
            if let error = error { print("Error: \(error.localizedDescription)") }
        }
    }
    
    func testAccountEffects() {
        print("\n---- \(#function)\n")
        
        let expect    = expectation(description: "ACCOUNT EFFECTS")
        let publicKey = testAddress
        let account   = StellarSDK.Account(publicKey, .test)
        
        account.getEffects { effects in
            print("RAW:", effects.raw ?? "?")
            print("----")
            print("Records", effects.records.count)
            for effect in effects.records {
                print("Effect:", effect.type ?? "?", effect.typeInt, effect.amount ?? "?")
            }
            XCTAssertNil(effects.error, "Error in server request")
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 20){ error in
            if let error = error { print("Error: \(error.localizedDescription)") }
        }
    }
    
    func testAccountOffers() {
        print("\n---- \(#function)\n")
        
        let expect    = expectation(description: "ACCOUNT OFFERS")
        let publicKey = testAddress
        let account   = StellarSDK.Account(publicKey, .test)
        
        account.getOffers { offers in
            print("RAW:", offers.raw ?? "?")
            print("----")
            print("Records", offers.records.count)
            for offer in offers.records {
                print("Offer:", offer.selling?.assetCode ?? "?", offer.buying?.assetCode ?? "?", offer.amount ?? "?", offer.price ?? "?")
            }
            XCTAssertNil(offers.error, "Error in server request")
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 20){ error in
            if let error = error { print("Error: \(error.localizedDescription)") }
        }
    }
    
    func testAccountData() {
        print("\n---- \(#function)\n")
        
        let expect    = expectation(description: "ACCOUNT DATA")
        let publicKey = testAddress
        let account   = StellarSDK.Account(publicKey, .test)
        
        account.getData(key: "Test") { value in
            print("Key", "Test")
            print("Value", value)
            XCTAssert(!value.isEmpty, "Error fetching account data")
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 20){ error in
            if let error = error { print("Error: \(error.localizedDescription)") }
        }
    }
    
    func testAccountFund() {
        print("\n---- \(#function)\n")
        
        let expect  = expectation(description: "ACCOUNT FUND")
        //let source  = testAddress
        let secret  = testSecret
        let keypair = KeyPair.random()
        let destin  = keypair.stellarPublicKey
        let account = StellarSDK.Account.fromSecret(secret)!
        
        print(account.keyPair!.publicKey)
        print(account.keyPair!.publicKey.xdr.base64)
        print("Funding account", destin)
        
        account.useTestNetwork()
        account.createAccount(address: destin, amount: 24, memo: "Hello World!") { response in
            print("\nResponse", response.raw)
            XCTAssert(!response.error, "Error funding account")
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 20){ error in
            if let error = error { print("Error: \(error.localizedDescription)") }
        }
    }

    func testAccountPayment() {
        print("\n---- \(#function)\n")
        
        let expect  = expectation(description: "ACCOUNT PAY")
        //let source  = testAddress
        let secret   = testSecret
        let destin   = testDestin
        let account  = StellarSDK.Account.fromSecret(secret)!
        
        print(account.keyPair!.publicKey)
        print(account.keyPair!.publicKey.xdr.base64)
        print("Funding account", destin)
        
        account.useTestNetwork()
        account.payment(address: destin, amount: 15.75, memo: "Hello World!") { response in
            print("\nResponse", response.raw)
            XCTAssert(!response.error, "Error sending payment")
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 20){ error in
            if let error = error { print("Error: \(error.localizedDescription)") }
        }
    }
    
    func testAccountInflation() {
        print("\n---- \(#function)\n")
        
        let expect   = expectation(description: "ACCOUNT PAY")
        //let source = testAddress
        let secret   = testSecret
        let destin   = testDestin
        let account  = StellarSDK.Account.fromSecret(secret)!
        
        print(account.keyPair!.publicKey)
        print(account.keyPair!.publicKey.xdr.base64)
        print("Set inflation to account", destin)
        
        account.useTestNetwork()
        account.setInflation(address: destin, memo: "Inflation") { response in
            print("\nResponse", response.raw)
            XCTAssert(!response.error, "Error sending payment")
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 20){ error in
            if let error = error { print("Error: \(error.localizedDescription)") }
        }
        
    }
    
    func testPerformanceExample() {
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
