# StellarSDK

Stellar SDK implementation as a Swift Framework to build Mac Apps. It provides a bridge between your app and Stellar Horizon Server to request information and submit transactions to the Stellar Network.

## Quick Start

Just git clone this repo and include the StellarSDK.xcodeproj in your own project, then use it as easy as:

````Swift
import StellarSDK

let account = StellarSDK.Account.random()
account.friendbot()       // Testing account will be funded with 10,000 XLM

print(account.publicKey)
print(account.secretKey)
````

## Account Class

The Account class is the most important of all as it allows us to generate Stellar addreses and to query for all kinds of operations for that account. 

To generate public and secret keys:

````Swift
let account = Account.random()                // Generates a new public/secret key pair
let account = Account.fromSecret("S1234...")  // Generates the public key from secret key
````

You can use the public or testing network for your requests:

````Swift
account.useNetwork(.test)
account.useNetwork(.live)
account.useTestNetwork()
account.usePublicNetwork()
````

The Account class provides a better implementation of responses from the Horizon server. Since request/response is asynchronous, we must wait for the server in order to process the results using Swift callbacks:

````Swift
account.getInfo { info in ... }
account.getPayments { payments in ... }
account.getOperations { operations in ... }
account.getTransactions { transactions in ... }
account.getEffects { effects in ... }
account.getOffers { offers in ... }
account.getData(key) { value in ... }
````

Requests that produce lists of records can accept options like cursor, order and limit: 

````Swift
account.getPayments(order: .desc, limit 20) { payments in ... }
account.getTransactions(limit 50) { transactions in ... }
````

## Horizon Class

Horizon class is a direct RPC bridge to Stellar Horizon Server that provides two ways to access information, one via direct call to the API endpoints returning raw payloads that need to be processed for consumption, while the most used way is a series of handlers that convert that information to more usable objects. Some of its public methods are:


### API Calls

All API calls to Horizon endpoints will return raw JSON for processing.

````Swift
let api = Horizon.live  // .test for testing

api.account(address) { response in ... }
api.accounts(options) { response in ... }
api.accountEffects(address, options) { response in ... }
api.accountOffers(address, options) { response in ... }
api.accountOperations(address, options) { response in ... }
api.accountPayments(address, options) { response in ... }
api.accountTransactions(address, options) { response in ... }
api.transaction(txid) { response in ... }
api.transactions(options) { response in ... }
api.transactionEffects(hash, options) { response in ... }
api.transactionOperations(hash, options) { response in ... }
api.transactionPayments(hash, options) { response in ... }
api.orderbook(options) { response in ... }
api.orderbookTrades(options) { response in ... }
api.ledgers(options) { response in ... }
api.ledger(id) { response in ... }
api.ledgerEffects(id, options) { response in ... }
api.ledgerOffers(id, options) { response in ... }
api.ledgerOperations(id, options) { response in ... }
api.ledgerPayments(id, options) { response in ... }
api.effects(options) { response in ... }
api.operation(id, options) { response in ... }
api.operations(options) { response in ... }
api.operationEffects(hash, options) { response in ... }
api.payments(options) { response in ... }
api.assets(options) { response in ... }
api.friendbot(address) { response in ... }
//api.submit(tx) { response in ... }
````

\* Right now api.submit is the only method not implemented.

### API Handlers

Some API calls have been wrapped around a handler so the payload received is presented as an easily consumable object according to SDKs implemented in different languages.

````Swift
let server = Horizon.live

server.loadAccount(address) { account in ... }
server.loadAccountOperations(address, options) { operations in ... }
server.loadAccountPayments(address, options) { payments in ... }
server.loadAccountTransactions(address, options) { transactions in ... }
server.loadAccountEffects(address, options) { effects in ... }
server.loadAccountOffers(address, options) { offers in ... }
//server.submitTransaction(tx) { response in ... }
````

\* Right now server.submitTransaction is the only method not implemented.

Chaining requests is also possible but barely functional:

````Swift
server.loadAccount(address) { account in
    account.transactions { transactions in ... }
}
````

\* Better chaining support will be added in the future.

## User Guide

Refer to the [StellarSDK User Guide](Docs/UserGuide.md) for more in-depth technical specifications.

## Unit tests

StellarSDK comes with a full suit of tests that can be run to validate its functionality.

## Ongoing development

StellarSDK is an ongoing project and will continue to add more functionality to bring it to par with other SDKs from different languages. Come back soon for more updates.

### TODO List:

[x] StellarSDK for macOS
[ ] StellarSDK for iOS
[ ] StellarSDK for iWatch

## External dependencies

[CryptoSwift](https://github.com/krzyzanowskim/CryptoSwift) by Marcin Krzyzanowski is a Crypto library in native Swift with no external dependencies.

## License

StellarSDK will use the most permissive license yet to be defined.