//
//  SettingWalletDetailTableViewCell.swift
//  loopr-ios
//
//  Created by xiaoruby on 5/14/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

class SettingWalletDetailTableViewCell: UITableViewCell {

    enum ContentType {
        case walletName
        case backupMnemonic
        case exportPrivateKey
        case exportKeystore
    }
    
    var contentType: ContentType!
    
    @IBOutlet weak var contentTypeLabel: UILabel!
    @IBOutlet weak var arrowRightIcon: UIImageView!
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var seperateLine: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        contentTypeLabel.font = FontConfigManager.shared.getLabelSCFont(size: 14)
        contentTypeLabel.textColor = UIColor.init(rgba: "#939BB1")
        
        actionLabel.font = FontConfigManager.shared.getLabelSCFont(size: 14)
        actionLabel.textColor = GlobalPicker.themeColor
        
        seperateLine.backgroundColor = UIColor.init(white: 0, alpha: 0.1)
    }
    
    func setup() {
        switch contentType {
        case .walletName:
            setupWalletName()
        case .backupMnemonic:
            setupBackupMnemonic()
        case .exportPrivateKey:
            setupExportPrivateKey()
        case .exportKeystore:
            setupExportKeystore()
        default:
            break
        }
    }
    
    func setupWalletName() {
        contentTypeLabel.text = LocalizedString("Update Wallet Name", comment: "")
        arrowRightIcon.isHidden = false
        actionLabel.isHidden = true
    }
    
    func setupBackupMnemonic() {
        contentTypeLabel.text = LocalizedString("Backup Mnemonic", comment: "")
        arrowRightIcon.isHidden = true
        actionLabel.isHidden = false
        actionLabel.text = LocalizedString("Backup", comment: "")
    }
    
    func setupExportPrivateKey() {
        contentTypeLabel.text = LocalizedString("Export Private Key", comment: "")
        arrowRightIcon.isHidden = true
        actionLabel.isHidden = false
        actionLabel.text = LocalizedString("Export", comment: "")
    }
    
    func setupExportKeystore() {
        contentTypeLabel.text = LocalizedString("Export Keystore", comment: "")
        arrowRightIcon.isHidden = true
        actionLabel.isHidden = false
        actionLabel.text = LocalizedString("Export", comment: "")
    }

    class func getCellIdentifier() -> String {
        return "SettingWalletDetailTableViewCell"
    }
    
    class func getHeight() -> CGFloat {
        return 54
    }
}
