//
//  SettingWalletDetailViewControllerDataSource.swift
//  loopr-ios
//
//  Created by xiaoruby on 5/14/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import Foundation
import UIKit

extension SettingWalletDetailViewController {

    func getNumberOfRowsInWalletSection() -> Int {
        if appWallet.setupWalletMethod == .create || appWallet.setupWalletMethod == .importUsingMnemonic {
            return 4
        } else {
            return 3
        }
    }

    func getTableViewCell(cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: SettingWalletDetailTableViewCell.getCellIdentifier()) as? SettingWalletDetailTableViewCell
        if cell == nil {
            let nib = Bundle.main.loadNibNamed("SettingWalletDetailTableViewCell", owner: self, options: nil)
            cell = nib![0] as? SettingWalletDetailTableViewCell
        }
        cell?.accessoryType = .none
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell?.contentType = .walletName
            } else if indexPath.row == 1 {
                cell?.contentType = .exportPrivateKey
            } else if indexPath.row == 2 {
                cell?.contentType = .exportKeystore
            } else if indexPath.row == 3 {
                cell?.contentType = .backupMnemonic
            }
        }
        cell?.setup()
        return cell!
    }

}
