//
//  UpdatedMnemonicSelectAddressViewController.swift
//  loopr-ios
//
//  Created by xiaoruby on 6/24/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

class UpdatedMnemonicSelectAddressViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // @IBOutlet weak var statusBarBackgroundView: UIView!
    // @IBOutlet weak var customizedNavigationBar: UINavigationBar!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var startInfolbel: UILabel!
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var selectedAddress: UILabel!
    
    @IBOutlet weak var hideTableViewButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        startInfolbel.font = UIFont.init(name: "Futura-Bold", size: 31*UIStyleConfig.scale)

        nextButton.addTarget(self, action: #selector(pressedNextButton), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        infoLabel.textColor = UIColor.tokenestTip
        infoLabel.font = FontConfigManager.shared.getLabelSCFont(size: 12)
        
        selectedAddress.textColor = UIColor.init(rgba: "#32384C")
        selectedAddress.font = FontConfigManager.shared.getLabelENFont(size: 18)
        selectedAddress.numberOfLines = 1
        selectedAddress.text = ImportWalletUsingMnemonicDataManager.shared.addresses[0].eip55String.getAddressFormat(length: 11)
        
        hideTableViewButton.addTarget(self, action: #selector(pressedHideTableViewButton), for: .touchUpInside)
        hideTableViewButton.setImage(UIImage.init(named: "Tokenest-setup-5-2-select-other-address-hide"), for: .normal)
        tableView.isHidden = true
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 10))
        headerView.backgroundColor = UIColor.init(rgba: "#F3F5F8")
        tableView.tableHeaderView = headerView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func pressedHideTableViewButton(_ sender: Any) {
        if tableView.isHidden {
            hideTableViewButton.setImage(UIImage.init(named: "Tokenest-setup-5-2-select-other-address"), for: .normal)
            tableView.isHidden = false
        } else {
            hideTableViewButton.setImage(UIImage.init(named: "Tokenest-setup-5-2-select-other-address-hide"), for: .normal)
            tableView.isHidden = true
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MnemonicAddressTableViewCell.getHeight()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ImportWalletUsingMnemonicDataManager.shared.addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: MnemonicAddressTableViewCell.getCellIdentifier()) as? MnemonicAddressTableViewCell
        if cell == nil {
            let nib = Bundle.main.loadNibNamed("MnemonicAddressTableViewCell", owner: self, options: nil)
            cell = nib![0] as? MnemonicAddressTableViewCell
            cell?.selectionStyle = .none
            cell?.tintColor = UIColor.black
        }
        
        if indexPath.row == 0 {
            cell?.indexLabel.text = LocalizedString("Default", comment: "")
            cell?.indexLabel.font = UIFont.init(name: FontConfigManager.shared.getMedium(), size: 16)
        } else {
            cell?.indexLabel.text = "\(indexPath.row+1)."
            cell?.indexLabel.font = UIFont.init(name: FontConfigManager.shared.getMedium(), size: 16)
        }

        cell?.addressLabel.font = UIFont.init(name: FontConfigManager.shared.getMedium(), size: 16)
        cell?.addressLabel.text = ImportWalletUsingMnemonicDataManager.shared.addresses[indexPath.row].eip55String.getAddressFormat(length: 11)
        
        if ImportWalletUsingMnemonicDataManager.shared.selectedKey == indexPath.row {
            cell?.addressLabel.textColor = GlobalPicker.themeColor
            cell?.indexLabel.textColor = GlobalPicker.themeColor
        } else {
            cell?.addressLabel.textColor = UIColor.tokenestTip
            cell?.indexLabel.textColor = UIColor.tokenestTip
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        ImportWalletUsingMnemonicDataManager.shared.selectedKey = indexPath.row
        selectedAddress.text = ImportWalletUsingMnemonicDataManager.shared.addresses[indexPath.row].eip55String.getAddressFormat(length: 11)
        tableView.reloadData()
    }
    
    @objc func pressedNextButton(_ sender: Any) {
        print("pressedNextButton")
        let viewController = UpdatedImportWalletEnterWalletNameViewController(setupWalletMethod: .importUsingMnemonic)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func backButtonPressed(_ sender: Any) {
        print("backButtonPressed")
        self.navigationController?.popViewController(animated: true)
    }

}
