//
//  WalletType.swift
//  loopr-ios
//
//  Created by xiaoruby on 6/24/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

class WalletType: Equatable {
    
    final let name: String
    final let derivationPath: String

    init(name: String, derivationPath: String) {
        self.name = name
        self.derivationPath = derivationPath
    }

    static func ==(lhs: WalletType, rhs: WalletType) -> Bool {
        return lhs.name == rhs.name && lhs.derivationPath == rhs.derivationPath
    }
    
    class func getDefault() -> WalletType {
        return WalletType(name: "Tokenest Wallet", derivationPath: "m/44'/60'/0'/0")
    }
}
