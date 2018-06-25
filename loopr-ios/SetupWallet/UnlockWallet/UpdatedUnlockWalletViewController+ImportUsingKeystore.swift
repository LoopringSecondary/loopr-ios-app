//
//  UpdatedUnlockWalletViewController+ImportUsingKeystore.swift
//  loopr-ios
//
//  Created by xiaoruby on 6/23/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import Foundation
import UIKit
import NotificationBannerSwift
import SVProgressHUD

extension UpdatedUnlockWalletViewController {
    
    func continueImportUsingKeystore(keystoreString: String, password: String) {
        print("pressedUnlockButton")
        // TODO: Use notificatino to require
        guard password != "" else {
            let notificationTitle = NSLocalizedString("Please enter a password", comment: "")
            let banner = NotificationBanner.generate(title: notificationTitle, style: .danger)
            banner.duration = 1.5
            banner.show()
            return
        }
        
        var isSucceeded: Bool = false
        SVProgressHUD.show(withStatus: NSLocalizedString("Importing keystore", comment: "") + "...")
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        DispatchQueue.global().async {
            do {
                try ImportWalletUsingKeystoreDataManager.shared.unlockWallet(keystoreStringValue: keystoreString, password: password)
                isSucceeded = true
                dispatchGroup.leave()
            } catch {
                isSucceeded = false
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            SVProgressHUD.dismiss()
            if isSucceeded {
                if AppWalletDataManager.shared.isDuplicatedAddress(address: ImportWalletUsingKeystoreDataManager.shared.address) {
                    let alert = UIAlertController(title: NSLocalizedString("Failed to import address. The device has imported the address already.", comment: ""), message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                        
                    }))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                self.continueImportUsingKeystoreJumpToNextViewController()
            } else {
                let banner = NotificationBanner.generate(title: "Wrong password", style: .danger)
                banner.duration = 1.5
                banner.show()
            }
        }
    }
    
    func continueImportUsingKeystoreJumpToNextViewController() {
        let viewController = UpdatedImportWalletEnterWalletNameViewController(setupWalletMethod: .importUsingKeystore)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
