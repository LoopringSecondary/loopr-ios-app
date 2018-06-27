//
//  H5DexDataManager.swift
//  loopr-ios
//
//  Created by 王忱 on 2018/6/25.
//  Copyright © 2018年 Loopring. All rights reserved.
//

import Foundation

class H5DexDataManager {
    
    static let shared = H5DexDataManager()
    
    var sendClosure: ((_ json: JSON) -> Void)?
    
    func handle(request: DexRequest) {
        switch request.method {
        case .getLrcFee:
            getLrcFee()
        case .getCurrency:
            getCurrency()
        case .getLanguage:
            getLanguage()
        case .getCurrentAccount:
            getCurrentAccount()
        case .signTx:
            signTx(request.data)
        case .signMessage:
            signMessage(request.data)
        case .unknownRequest:
            break
        }
    }
    
    func getCurrency() {
        let result = SettingDataManager.shared.getCurrentCurrency().name
        self.completion(result, nil)
    }
    
    func getLrcFee() {
        let result = SettingDataManager.shared.getLrcFeeRatio()
        self.completion(result, nil)
    }
    
    func getLanguage() {
        let result = SettingDataManager.shared.getCurrentLanguage().name
        self.completion(result, nil)
    }
    
    func getCurrentAccount() {
        let result = CurrentAppWalletDataManager.shared.getCurrentAppWallet()?.address
        self.completion(result, nil)
    }
    
    func signTx(_ json: JSON?) {
        if let json = json {
            let rawTx = RawTransaction(json: json)
            let signed = SendCurrentAppWalletDataManager.shared._sign(rawTx: rawTx) { (_, error) in
                guard error != nil else {
                    self.completion("", error!)
                    return
                }
            }
            self.completion(signed, nil)
        }
    }
    
    func signMessage(_ json: JSON?) {
        if let json = json {
            var data: Data = Data()
            data.append(contentsOf: json.stringValue.hexBytes)
            SendCurrentAppWalletDataManager.shared._keystore()
            if case (let signature?, _) = web3swift.sign(message: data) {
                self.completion(signature, nil)
            }
        }
    }
    
    func completion(_ result: Double?, _ error: Error?) {
        var body = JSON()
        if let error = error as NSError? {
            body["errorCode"] = JSON(error.code)
            body["message"] = JSON(error.userInfo["message"] ?? "unknown error")
        } else if let result = result {
            body["result"] = JSON(result)
        }
        if let closure = self.sendClosure {
            closure(body)
        }
    }
    
    func completion(_ result: String?, _ error: Error?) {
        var body = JSON()
        if let error = error as NSError? {
            body["errorCode"] = JSON(error.code)
            body["message"] = JSON(error.userInfo["message"] ?? "unknown error")
        } else if let result = result {
            body["result"] = JSON(result)
        }
        if let closure = self.sendClosure {
            closure(body)
        }
    }
    
    func completion(_ result: SignatureData?, _ error: Error?) {
        var body = JSON()
        if let error = error as NSError? {
            body["errorCode"] = JSON(error.code)
            body["message"] = JSON(error.userInfo["message"] ?? "unknown error")
        } else if let result = result {
            body["result"] = ["r": JSON(result.r), "s": JSON(result.s), "v": JSON(Int(result.v)!)]
        }
        if let closure = self.sendClosure {
            closure(body)
        }
    }
}
