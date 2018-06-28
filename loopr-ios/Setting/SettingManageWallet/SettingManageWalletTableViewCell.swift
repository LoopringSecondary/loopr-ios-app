//
//  SettingManageWalletTableViewCell.swift
//  loopr-ios
//
//  Created by xiaoruby on 4/6/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

class SettingManageWalletTableViewCell: UITableViewCell {

    var wallet: AppWallet?
    
    @IBOutlet weak var baseView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var toatalBalanceLabel: UILabel!
    
    var pressedNeedVerifiedButtonClosure: (() -> Void)?
    var needVerifiedButton: UIButton = UIButton()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = UIColor.init(rgba: "#F3F6F8")
        selectionStyle = .none
        
        baseView.backgroundColor = UIColor.white
        baseView.cornerRadius = 7.5
        nameLabel.font = FontConfigManager.shared.getLabelENFont(size: 21)
        addressLabel.font = FontConfigManager.shared.getLabelSCFont(size: 14)
        addressLabel.textColor = UIColor.init(rgba: "#878FA4")
        addressLabel.backgroundColor = UIColor.init(rgba: "#F4F6F8")
        addressLabel.cornerRadius = 9.0
        toatalBalanceLabel.font = FontConfigManager.shared.getLabelENFont(size: 20)
        toatalBalanceLabel.textColor = UIColor.init(rgba: "#3658ED")
        
        needVerifiedButton.setTitle(NSLocalizedString("Backup_Mnemonic_in_SettingManageWallet", comment: ""), for: .normal)
        needVerifiedButton.titleLabel?.font = FontConfigManager.shared.getLabelSCFont(size: 10)
        needVerifiedButton.setTitleColor(UIColor.init(rgba: "#8997F3"), for: .normal)
        needVerifiedButton.setTitleColor(UIColor.init(rgba: "#8997F3").withAlphaComponent(0.7), for: .normal)
        needVerifiedButton.layer.borderWidth = 1
        needVerifiedButton.layer.borderColor = UIColor.init(rgba: "#8997F3").cgColor
        needVerifiedButton.layer.cornerRadius = 7.5
        baseView.addSubview(needVerifiedButton)
        needVerifiedButton.isHidden = true
        
        needVerifiedButton.addTarget(self, action: #selector(pressedNeedVerifiedButton(_:)), for: UIControlEvents.touchUpInside)
    }

    func update() {
        if let wallet = wallet {
            nameLabel.text = wallet.name
            addressLabel.text = wallet.address.getAddressFormat()
            toatalBalanceLabel.text = wallet.totalCurrency.currency
            
            if wallet.isVerified {
                needVerifiedButton.isHidden = true
            } else {
                print(nameLabel.frame.maxX + nameLabel.intrinsicContentSize.width + 10)
                needVerifiedButton.frame = CGRect.init(x: nameLabel.frame.minX + nameLabel.intrinsicContentSize.width + 10, y: nameLabel.frame.midY - 12, width: 68, height: 22)
                needVerifiedButton.isHidden = false
            }
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        print("hightlighted: \(highlighted)")
        if highlighted {
            print("change color")
            baseView.backgroundColor = UIStyleConfig.tableCellSelectedBackgroundColor
        } else {
            print("reset color")
            baseView.backgroundColor = UIColor.white
        }
    }
    
    @objc func pressedNeedVerifiedButton(_ sender: UIButton) {
        if let btnAction = self.pressedNeedVerifiedButtonClosure {
            btnAction()
        }
    }
    
    class func getCellIdentifier() -> String {
        return "SelectWalletTableViewCell"
    }
    
    class func getHeight() -> CGFloat {
        return 118
    }
}
