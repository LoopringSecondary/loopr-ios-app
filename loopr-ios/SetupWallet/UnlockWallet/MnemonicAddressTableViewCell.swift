//
//  MnemonicAddressTableViewCell.swift
//  loopr-ios
//
//  Created by xiaoruby on 4/15/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

class MnemonicAddressTableViewCell: UITableViewCell {

    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        accessoryType = .none
        backgroundColor = UIColor.init(rgba: "#F3F5F8")
        
        indexLabel.textAlignment = .center
    }
    
    class func getCellIdentifier() -> String {
        return "MnemonicAddressTableViewCell"
    }
    
    class func getHeight() -> CGFloat {
        return 51
    }
}
