//
//  SwitchImportWalletWalletTypeViewController.swift
//  loopr-ios
//
//  Created by xiaoruby on 6/24/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

protocol SwitchImportWalletWalletTypeViewControllerDelegate: class {
    func selectedImportWalletWalletType(_ selectedWalletType: WalletType?)
}

class SwitchImportWalletWalletTypeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    weak var delegate: SwitchImportWalletWalletTypeViewControllerDelegate?

    let walletTypes: [WalletType] = [
        WalletType.getDefault(),
        WalletType(name: "Loopring Wallet", derivationPath: "m/44'/60'/0'/0"),
        WalletType(name: "Metamask", derivationPath: "m/44'/60'/0'/0"),
    ]
    var currentWalletType: WalletType = WalletType.getDefault()
    var selectedWalletType: WalletType?

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var importWalletButton: UIButton!
    @IBOutlet weak var seperateLine: UIView!
    @IBOutlet weak var imporWalletArrowButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.modalPresentationStyle = .custom
        
        backgroundView.backgroundColor = UIColor.clear
        let scrollViewTap = UITapGestureRecognizer(target: self, action: #selector(dismissViewController))
        scrollViewTap.numberOfTapsRequired = 1
        backgroundView.addGestureRecognizer(scrollViewTap)
        
        importWalletButton.titleLabel?.text = NSLocalizedString("Select Your Wallet Type", comment: "")
        importWalletButton.titleLabel?.font = FontConfigManager.shared.getLabelSCFont(size: 16, type: "Medium")
        importWalletButton.setTitleColor(UIColor.init(rgba: "#4A5668"), for: .normal)
        importWalletButton.setTitleColor(UIColor.init(rgba: "#4A5668").withAlphaComponent(0.7), for: .highlighted)
        importWalletButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        
        seperateLine.backgroundColor = UIColor.init(rgba: "#979797")
        
        imporWalletArrowButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return walletTypes.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 47
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "SwitchImportWalletMethodTableViewCell")
        cell.selectionStyle = .none
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = walletTypes[indexPath.row].name
        
        cell.textLabel?.font = FontConfigManager.shared.getLabelSCFont(size: 16)
        if selectedWalletType == nil {
            if currentWalletType == walletTypes[indexPath.row] {
                cell.textLabel?.textColor = GlobalPicker.themeColor
            } else {
                cell.textLabel?.textColor = UIColor.init(rgba: "#32384C")
            }
        } else {
            if selectedWalletType! == walletTypes[indexPath.row] {
                cell.textLabel?.textColor = GlobalPicker.themeColor
            } else {
                cell.textLabel?.textColor = UIColor.init(rgba: "#32384C")
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedWalletType = walletTypes[indexPath.row]
        tableView.reloadData()
    }
    
    @objc func dismissViewController() {
        delegate?.selectedImportWalletWalletType(selectedWalletType)
        self.dismiss(animated: true) {
            
        }
    }

}
