//
//  TxType.swift
//  loopr-ios
//
//  Created by xiaoruby on 6/2/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import Foundation

extension Transaction {
    enum TxType: String, CustomStringConvertible {
        case approved = "approve"
        case sent = "send"
        case received = "receive"
        case sold = "sell"
        case bought = "buy"
        case convert_income = "convert_income"
        case convert_outcome = "convert_outcome"
        case canceledOrder = "cancel_order"
        case cutoff = "cutoff"
        case unsupportedContract = "unsupported_contract"
        
        var description: String {
            switch self {
            case .approved: return LocalizedString("Enabled", comment: "")
            case .sent: return LocalizedString("Sent", comment: "")
            case .received: return LocalizedString("Received", comment: "")
            case .sold: return LocalizedString("Sold", comment: "")
            case .bought: return LocalizedString("Bought", comment: "")
            case .convert_income: return LocalizedString("Convert", comment: "") // eth <-> weth
            case .convert_outcome: return LocalizedString("Convert", comment: "") // eth <-> weth
            case .canceledOrder: return LocalizedString("Cancel Order(s)", comment: "")
            case .cutoff: return LocalizedString("Cancel Order(s)", comment: "")
            case .unsupportedContract: return LocalizedString("Unknown", comment: "")
            }
        }
    }
}
