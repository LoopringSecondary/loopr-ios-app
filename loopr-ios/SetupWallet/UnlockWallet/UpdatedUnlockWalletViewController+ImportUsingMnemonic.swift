//
//  UpdatedUnlockWalletViewController+ImportUsingMnemonic.swift
//  loopr-ios
//
//  Created by xiaoruby on 6/23/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import Foundation

extension UpdatedUnlockWalletViewController {
    
    func continueImportUsingMnemonic(memonicString: String, password: String) {
        ImportWalletUsingMnemonicDataManager.shared.mnemonic = memonicString.trim()
        ImportWalletUsingMnemonicDataManager.shared.password = password
        ImportWalletUsingMnemonicDataManager.shared.generateAddresses()
        
        let viewController = UpdatedMnemonicSelectAddressViewController(nibName: "UpdatedMnemonicSelectAddressViewController", bundle: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
    }

}
