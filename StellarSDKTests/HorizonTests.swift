//
//  HorizonTests.swift
//  StellarSDK
//
//  Created by Laptop on 1/25/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import XCTest
@testable import StellarSDK

class HorizonTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here.
    }
    
    override func tearDown() {
        // Put teardown code here.
        super.tearDown()
    }

    func testApiAccount() {
        print("\n---- \(#function)\n")
        
        let expect    = expectation(description: "GET ACCOUNT")
        let publicKey = "GAJ54B2Q73XHXMKLGUWNUQL5XZLIS3ML7MHRNICYBWBLQQDVESJJNNMJ"
        let server    = StellarSDK.Horizon.test
        
        server.account(address: publicKey) { response in
            //print("Raw:", response.raw)
            let account = StellarSDK.AccountResponse(response.json)
            print("Id"           , account.id            ?? "?")
            print("Account id"   , account.accountId     ?? "?")
            print("Paging token" , account.pagingToken   ?? "?")
            print("Sequence"     , account.sequence      ?? "?")
            print("SubentryCount", account.subentryCount)
            print("Thresholds"   , account.thresholds    ?? "?")
            print("Flags"        , account.flags         ?? "?")
            print("Balances"     , account.balances)
            print("Signers"      , account.signers)
            print("Data"         , account.data)
            print("Links"        , account.links         ?? "?")
            XCTAssert(response.status == 200, "Error in server request")
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 10){ error in
            if let error = error { print("Error: \(error.localizedDescription)") }
        }
    }

    func testGetAccount() {
        
        print("\n---- \(#function)\n")
        let expect    = expectation(description: "GET ACCOUNT")
        let publicKey = "GAJ54B2Q73XHXMKLGUWNUQL5XZLIS3ML7MHRNICYBWBLQQDVESJJNNMJ"
        let server    = StellarSDK.Horizon.test
        
        server.loadAccount(publicKey) { account in
            //print("Raw:", response.raw)
            //let account = StellarSDK.AccountResponse(response.json)
            if account.error != nil {
                print(account.error!.text)
                XCTAssertTrue(account.error!.code > 0)
            } else {
                print("Id"           , account.id            ?? "?")
                print("Account id"   , account.accountId     ?? "?")
                print("Paging token" , account.pagingToken   ?? "?")
                print("Sequence"     , account.sequence      ?? "?")
                print("SubentryCount", account.subentryCount)
                print("Thresholds"   , account.thresholds    ?? "?")
                print("Flags"        , account.flags         ?? "?")
                print("Balances"     , account.balances)
                print("Signers"      , account.signers)
                print("Data"         , account.data)
                print("Links"        , account.links         ?? "?")
                XCTAssertTrue(!(account.id?.isEmpty)!, "Error in server request")
            }
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 10){ error in
            if let error = error { print("Error: \(error.localizedDescription)") }
        }
    }

    func testGetAccountTransactions() {
        print("\n---- \(#function)\n")
        
        let expect    = expectation(description: "GET ACCOUNT TRANSACTIONS")
        let publicKey = "GAJ54B2Q73XHXMKLGUWNUQL5XZLIS3ML7MHRNICYBWBLQQDVESJJNNMJ"
        let server    = StellarSDK.Horizon.test
        
        server.loadAccount(publicKey) { account in
            print("Account id", account.accountId ?? "?")
            account.transactions(options: nil){ transactions in
                print("Records", transactions.records.count)
                XCTAssertTrue(!(account.id?.isEmpty)!, "Error in server request")
                expect.fulfill()
            }
        }
        
        waitForExpectations(timeout: 20){ error in
            if let error = error { print("Error: \(error.localizedDescription)") }
        }
    }

    func testFriendbot() {
        print("\n---- \(#function)\n")
        
        let expect    = expectation(description: "FUND ACCOUNT")
        let publicKey = KeyPair.random().publicKey.base32
        let server    = StellarSDK.Horizon.test
        
        server.friendbot(address: publicKey) { response in
            print("Raw:", response.raw)
            XCTAssert(response.status == 200, "Error in server request")
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 20){ error in
            if let error = error { print("Error: \(error.localizedDescription)") }
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
