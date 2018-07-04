//
//  SettingPasscodeTableViewCell.swift
//  loopr-ios
//
//  Created by xiaoruby on 5/26/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

class SettingPasscodeTableViewCell: UITableViewCell {

    @IBOutlet weak var passcodeLabel: UILabel!
    @IBOutlet weak var passcodeSwitch: UISwitch!
    @IBOutlet weak var seperateLine: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        seperateLine.backgroundColor = UIColor.init(rgba: "#E5E7ED")
        
        passcodeLabel.text = BiometricType.get().description
        passcodeLabel.textColor = UIColor.init(rgba: "#939BB1")
        passcodeLabel.font = FontConfigManager.shared.getLabelSCFont(size: 14)
        
        passcodeSwitch.transform = CGAffineTransform(scaleX: 0.81, y: 0.81)
        passcodeSwitch.setOn(AuthenticationDataManager.shared.getPasscodeSetting(), animated: false)
        
        if AuthenticationDataManager.shared.devicePasscodeEnabled() {
            passcodeSwitch.isHidden = false
            selectionStyle = .none
        } else {
            passcodeSwitch.isHidden = true
        }
    }
    
    @IBAction func togglePasscodeSwitch(_ sender: Any) {
        AuthenticationDataManager.shared.setPasscodeSetting(passcodeSwitch.isOn)
    }

    class func getCellIdentifier() -> String {
        return "SettingThemeModeTableViewCell"
    }
    
    class func getHeight() -> CGFloat {
        return 45
    }

}
