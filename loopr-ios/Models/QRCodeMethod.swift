//
//  SetupWalletMethod.swift
//  loopr-ios
//
//  Created by xiaoruby on 4/15/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import Foundation

enum QRCodeMethod: String {

    case create = "SetupWalletMethod.create"
    case importUsingMnemonic = "SetupWalletMethod.importUsingMnemonic"
    case importUsingKeystore = "SetupWalletMethod.importUsingKeystore"
    case importUsingPrivateKey = "SetupWalletMethod.importUsingPrivateKey"
    case authorization = "Authorization"

    var description: String {
        switch self {
        case .create: return NSLocalizedString("Create", comment: "")
        case .importUsingMnemonic: return NSLocalizedString("Mnemonic", comment: "")
        case .importUsingKeystore: return NSLocalizedString("Keystore", comment: "")
        case .importUsingPrivateKey: return NSLocalizedString("Private Key", comment: "")
        case .authorization: return NSLocalizedString("Authorization", comment: "")
        }
    }
    
    // The following methods are to choose the type quickly. No computation should be added.
    static func isMnemonicValid(mnemonic: String) -> Bool {
        return Mnemonic.isValid(mnemonic)
    }
    
    static func isPrivateKey(key: String) -> Bool {
        let keyContent = key.uppercased()
        if keyContent.count != 64 {
            return false
        }
        for ch in keyContent {
            if (ch >= "0" && ch <= "9") || (ch >= "A" && ch <= "F") {
                continue
            }
            return false
        }
        return true
    }
    
    static func isKeystore(content: String) -> Bool {
        let jsonData = content.data(using: String.Encoding.utf8)
        if let jsonObject = try? JSONSerialization.jsonObject(with: jsonData!, options: []) {
            if JSONSerialization.isValidJSONObject(jsonObject) {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    static func isP2POrder(content: String) -> Bool {
        return content.contains("-")
    }
    
    static func isSubmitOrder(content: String) -> Bool {
        if let data = content.data(using: .utf8) {
            let json = JSON(data)
            if json["type"] == "sign" {
                AuthorizeDataManager.shared.submitHash = json["value"].stringValue
                return true
            }
        }
        return false
    }
    
    static func isLogin(content: String) -> Bool {
        if let data = content.data(using: .utf8) {
            let json = JSON(data)
            if json["type"] == "UUID" {
                AuthorizeDataManager.shared.loginUUID = json["value"].stringValue
                return true
            }
        }
        return false
    }
    
    static func isCancelOrder(content: String) -> Bool {
        if let data = content.data(using: .utf8) {
            let json = JSON(data)
            if json["type"] == "cancelOrder" {
                AuthorizeDataManager.shared.cancelHash = json["value"].stringValue
                return true
            }
        }
        return false
    }
    
    static func isConvert(content: String) -> Bool {
        if let data = content.data(using: .utf8) {
            let json = JSON(data)
            if json["type"] == "convert" {
                AuthorizeDataManager.shared.convertHash = json["value"].stringValue
                return true
            }
        }
        return false
    }
}
