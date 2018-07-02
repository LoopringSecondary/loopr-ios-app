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
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        startInfolbel.font = UIFont.init(name: "Futura-Bold", size: 31)

        nextButton.addTarget(self, action: #selector(pressedNextButton), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        infoLabel.textColor = UIColor.tokenestTip
        infoLabel.font = FontConfigManager.shared.getLabelSCFont(size: 12)
        
        selectedAddress.textColor = UIColor.init(rgba: "#32384C")
        selectedAddress.font = FontConfigManager.shared.getLabelSCFont(size: 18)
        selectedAddress.numberOfLines = 2
        selectedAddress.text = ImportWalletUsingMnemonicDataManager.shared.addresses[0].eip55String
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        cell?.indexLabel.text = "\(indexPath.row+1)."
        cell?.addressLabel.text = ImportWalletUsingMnemonicDataManager.shared.addresses[indexPath.row].eip55String
        
        if ImportWalletUsingMnemonicDataManager.shared.selectedKey == indexPath.row {
            cell?.accessoryType = .checkmark
        } else {
            cell?.accessoryType = .none
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        ImportWalletUsingMnemonicDataManager.shared.selectedKey = indexPath.row
        selectedAddress.text = ImportWalletUsingMnemonicDataManager.shared.addresses[indexPath.row].eip55String
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
