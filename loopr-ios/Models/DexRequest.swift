//
//  DexRequest.swift
//  loopr-ios
//
//  Created by 王忱 on 2018/6/25.
//  Copyright © 2018年 Loopring. All rights reserved.
//

import Foundation

class DexRequest {
    var data: JSON!
    var callback: String!
    var method: DexRequestType
    
    init(json: JSON) {
        self.data = json["data"]
        self.callback = json["callback"].stringValue
        self.method = DexRequestType(rawValue: json["method"].stringValue) ?? .unknownRequest
    }
}

extension DexRequest {
    enum DexRequestType: String {
        case getLanguage
        case getCurrency
        case getLrcFee
        case getCurrentAccount
        case signTx
        case signMessage
        case unknownRequest
    }
}
