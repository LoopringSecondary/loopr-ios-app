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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        passcodeLabel.text = BiometricType.get().description
        passcodeLabel.font = FontConfigManager.shared.getLabelENFont()
        
        passcodeSwitch.transform = CGAffineTransform(scaleX: 0.81, y: 0.81)
        passcodeSwitch.setOn(AuthenticationDataManager.shared.getPasscodeSetting(), animated: false)
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
