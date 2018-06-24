//
//  UpdatedUnlockWalletViewController+ImportUsingPrivateKey.swift
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
    
    func continueImportUsingPrivateKey(privateKey: String) {
        print("pressedUnlockButton")
        do {
            try ImportWalletUsingPrivateKeyDataManager.shared.importWallet(privateKey: privateKey)
            
            // Check if it's duplicated.
            if AppWalletDataManager.shared.isDuplicatedAddress(address: ImportWalletUsingPrivateKeyDataManager.shared.address) {
                let alert = UIAlertController(title: NSLocalizedString("Failed to import address. The device has imported the address already.", comment: ""), message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                    
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            // Generate a keystore
            generateTempKeystore()
            
        } catch {
            let banner = NotificationBanner.generate(title: NSLocalizedString("Invalid private key. Please enter again.", comment: ""), style: .danger)
            banner.duration = 1.5
            banner.show()
        }
    }
    
    func generateTempKeystore() {
        var isSucceeded: Bool = false
        SVProgressHUD.show(withStatus: NSLocalizedString("Initializing the wallet", comment: "") + "...")
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        DispatchQueue.global().async {
            do {
                guard let data = Data(hexString: ImportWalletUsingPrivateKeyDataManager.shared.getPrivateKey()) else {
                    print("Invalid private key")
                    return // .failure(KeystoreError.failedToImportPrivateKey)
                }
                
                print("Generating keystore")
                let key = try KeystoreKey(password: "123456", key: data)
                print("Finished generating keystore")
                let keystoreData = try JSONEncoder().encode(key)
                let json = try JSON(data: keystoreData)
                
                ImportWalletUsingPrivateKeyDataManager.shared.setKeystore(keystore: json.description)
                
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
                let viewController = ImportWalletEnterWalletNameViewController(setupWalletMethod: .importUsingPrivateKey)
                self.navigationController?.pushViewController(viewController, animated: true)
            } else {
                let banner = NotificationBanner.generate(title: "Wrong password", style: .danger)
                banner.duration = 1.5
                banner.show()
            }
        }
    }
    
    func continueImportUsingPrivateKeyJumpToNextViewController() {
        let viewController = ImportWalletEnterWalletNameViewController(setupWalletMethod: .importUsingKeystore)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
