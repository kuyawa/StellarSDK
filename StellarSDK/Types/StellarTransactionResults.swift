//
//  StellarTransactionResults.swift
//  StellarSDK
//
//  Created by Laptop on 2/3/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Foundation

// Second part of StellarTransaction.x

// Operation Results section

// This result is used when offers are taken during an operation
public struct ClaimOfferAtom {
    // emitted to identify the offer
    let sellerID: AccountID // Account that owns the offer
    let offerID: UInt64
    // amount and asset taken from the owner
    let assetSold: Asset
    let amountSold: Int64
    // amount and asset sent to the owner
    let assetBought: Asset
    let amountBought: Int64
}

// CreateAccount Result
public enum CreateAccountResultCode: Int8 {
    // codes considered as "success" for the operation
    case Success      =  0  // account was created
    // codes considered as "failure" for the operation
    case Malformed    = -1  // invalid destination
    case Underfunded  = -2  // not enough funds in source account
    case LowReserve   = -3  // would create an account below the min reserve
    case AlreadyExist = -4  // account already exists
}

public enum CreateAccountResult {
    case Success (Void)
    case Default (Void) // ?
}

/******* Payment Result ********/

public enum PaymentResultCode: Int8 {
    // codes considered as "success" for the operation
    case Success          =  0  // payment successfuly completed
    // codes considered as "failure" for the operation
    case Malformed        = -1  // bad input
    case Underfunded      = -2  // not enough funds in source account
    case SrcNoTrust       = -3  // no trust line on source account
    case SrcNotAuthorized = -4  // source not authorized to transfer
    case NoDestination    = -5  // destination account does not exist
    case NoTrust          = -6  // destination missing a trust line for asset
    case NotAuthorized    = -7  // destination not authorized to hold asset
    case LineFull         = -8  // destination would go above their limit
    case NoIssuer         = -9  // missing issuer on asset
}

public enum PaymentResult {
    case Success (Void)
    case Default (Void)
}

/******* Payment Result ********/

public enum PathPaymentResultCode: Int8 {
    // codes considered as "success" for the operation
    case Success          =   0  // success
    // codes considered as "failure" for the operation
    case Malformed        =  -1  // bad input
    case Underfunded      =  -2  // not enough funds in source account
    case SrcNoTrust       =  -3  // no trust line on source account
    case SrcNotAuthorized =  -4  // source not authorized to transfer
    case NoDestination    =  -5  // destination account does not exist
    case NoTrust          =  -6  // dest missing a trust line for asset
    case NotAuthorized    =  -7  // dest not authorized to hold asset
    case LineFull         =  -8  // dest would go above their limit
    case NoIssuer         =  -9  // missing issuer on one asset
    case TooFewOffers     = -10  // not enough offers to satisfy path
    case OfferCrossSelf   = -11  // would cross one of its own offers
    case OverSendmax      = -12  // could not satisfy sendmax
}

public struct SimplePaymentResult {
    let destination: AccountID
    let asset: Asset
    let amount: Int64
}

public struct PathPaymentSuccess {
    let offers: [ClaimOfferAtom]
    let last: SimplePaymentResult
}

public enum PathPaymentResult {
    case Success  (PathPaymentSuccess)
    case NoIssuer (Asset) // the asset that caused the error
    case Default  (Void)
}

/******* ManageOffer Result ********/

public enum ManageOfferResultCode: Int8 {
    // codes considered as "success" for the operation
    case Success           =   0
    // codes considered as "failure" for the operation
    case Malformed         =  -1   // generated offer would be invalid
    case SellNoTrust       =  -2   // no trust line for what we're selling
    case BuyNoTrust        =  -3   // no trust line for what we're buying
    case SellNotAuthorized =  -4   // not authorized to sell
    case BuyNotAuthorized  =  -5   // not authorized to buy
    case LineFull          =  -6   // can't receive more of what it's buying
    case Underfunded       =  -7   // doesn't hold what it's trying to sell
    case CrossSelf         =  -8   // would cross an offer from the same user
    case SellNoIssuer      =  -9   // no issuer for what we're selling
    case BuyNoIssuer       = -10   // no issuer for what we're buying
    // update errors
    case NotFound          = -11   // offerID does not match an existing offer
    case LowReserve        = -12   // not enough funds to create a new Offer
}

public enum ManageOfferEffect {
    case Created
    case Updated
    case Deleted
}

public enum ManageOfferEffectEntry {
    case Created
    case Updated (OfferEntry)
    case Default (Void)
}

public struct ManageOfferSuccessResult {
    // offers that got claimed while creating this offer
    let offersClaimed: [ClaimOfferAtom]
    let offer: ManageOfferEffectEntry  // ?
}

public enum ManageOfferResult {
    case Success (ManageOfferSuccessResult)
    case Default (Void)
}

/******* SetOptions Result ********/

public enum SetOptionsResultCode: Int8 {
    // codes considered as "success" for the operation
    case Success             =  0
    // codes considered as "failure" for the operation
    case LowReserve          = -1  // not enough funds to add a signer
    case TooManySigners      = -2  // max number of signers already reached
    case BadFlags            = -3  // invalid combination of clear/set flags
    case InvalidInflation    = -4  // inflation account does not exist
    case CantChange          = -5  // can no longer change this option
    case UnknownFlag         = -6  // can't set an unknown flag
    case ThresholdOutOfRange = -7  // bad value for weight/threshold
    case BadSigner           = -8  // signer cannot be masterkey
    case InvalidHomeDomain   = -9  // malformed home domain
}

public enum SetOptionsResult {
    case SET_OPTIONS_SUCCESS (Void)
    case Default (Void)
}

/******* ChangeTrust Result ********/

public enum ChangeTrustResultCode: Int8 {
    // codes considered as "success" for the operation
    case Success        =  0
    // codes considered as "failure" for the operation
    case Malformed      = -1  // bad input
    case NoIssuer       = -2  // could not find issuer
    case InvalidLimit   = -3  // cannot drop limit below balance, cannot create with a limit of 0
    case LowReserve     = -4  // not enough funds to create a new trust line,
    case SelfNotAllowed = -5  // trusting self is not allowed
}

public enum ChangeTrustResult {
    case Success (Void)
    case Default (Void)
}


/******* AllowTrust Result ********/

public enum AllowTrustResultCode: Int8 {
    // codes considered as "success" for the operation
    case Success            =  0
    // codes considered as "failure" for the operation
    case Malformed          = -1  // asset is not ASSET_TYPE_ALPHANUM
    case No_trust_line      = -2  // trustor does not have a trustline
    case Trust_not_required = -3  // source account does not require trust
    case Cant_revoke        = -4  // source account can't revoke trust,
    case Self_not_allowed   = -5  // trusting self is not allowed
}

public enum AllowTrustResult {
    case Success (Void)
    case Default (Void)
}

/******* AccountMerge Result ********/

public enum AccountMergeResultCode: Int8 {
    // codes considered as "success" for the operation
    case Success       =  0
    // codes considered as "failure" for the operation
    case Malformed     = -1  // can't merge onto itself
    case NoAccount     = -2  // destination does not exist
    case ImmutableSet  = -3  // source account has AUTH_IMMUTABLE set
    case HasSubEntries = -4  // account has trust lines/offers
}

public enum AccountMergeResult {
    case Success (Int64)   // how much got transfered from source account
    case Default (Void)
}

/******* Inflation Result ********/

public enum InflationResultCode: Int8 {
    // codes considered as "success" for the operation
    case Success =  0
    // codes considered as "failure" for the operation
    case NotTime = -1
}

public struct InflationPayout { // or use PaymentResultAtom to limit types?
    let destination: AccountID
    let amount: Int64
}

public enum InflationResult {
    case Success ([InflationPayout])
    case Default (Void)
}

/******* ManageData Result ********/

public enum ManageDataResultCode: Int8 {
    // codes considered as "success" for the operation
    case Success          =  0
    // codes considered as "failure" for the operation
    case NotSupportedYyet = -1  // The network hasn't moved to this protocol change yet
    case NameNotFound     = -2  // Trying to remove a Data Entry that isn't there
    case LowReserve       = -3  // not enough funds to create a new Data Entry
    case InvalidName      = -4  // Name not a valid string
}

public enum ManageDataResult {
    case Success (Void)
    case Default (Void)
}

/* High level Operation Result */

public enum OperationResultCode: Int8 {
    case Inner     =  0  // inner object result is valid
    case BadAuth   = -1  // too few valid signatures / wrong network
    case NoAccount = -2  // source account was not found
}

public enum OperationResultType {
    case CreateAccount      (CreateAccountResult)
    case Payment            (PaymentResult)
    case PathPayment        (PathPaymentResult)
    case ManageOffer        (ManageOfferResult)
    case CreatePassiveOffer (ManageOfferResult)
    case SetOptions         (SetOptionsResult)
    case ChangeTrust        (ChangeTrustResult)
    case AllowTrust         (AllowTrustResult)
    case AccountMerge       (AccountMergeResult)
    case Inflation          (InflationResult)
    case ManageData         (ManageDataResult)
}

public enum OperationResult {
    case Inner   (OperationResultType)
    case Default (Void)
}

public enum TransactionResultCode: Int8 {
    case Success             =   0  // all operations succeeded
    case Failed              =  -1  // one of the operations failed (none were applied)
    case TooEarly            =  -2  // ledger closeTime before minTime
    case TooLate             =  -3  // ledger closeTime after maxTime
    case MissingOperation    =  -4  // no operation was specified
    case BadSeq              =  -5  // sequence number does not match source account
    case BadAuth             =  -6  // too few valid signatures / wrong network
    case InsufficientBalance =  -7  // fee would bring account below reserve
    case NoAccount           =  -8  // source account not found
    case InsufficientFee     =  -9  // fee is too small
    case BadAuthExtra        = -10  // unused signatures attached to transaction
    case InternalError       = -11  // an unknown error occured
}

public enum TransactionResults {
    case Success ([OperationResult])
    case Failed  ([OperationResult])
    case Default (Void)
}

public struct TransactionResult {
    let feeCharged: Int64 // actual fee charged for the transaction
    let results: TransactionResults
    let ext: Reserved
}

// END
