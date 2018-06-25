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
        WalletType(name: "imtoken", derivationPath: "m/44'/60'/0'/0"),
        WalletType(name: "Metamask", derivationPath: "m/44'/60'/0'/0"),
        WalletType(name: "TREZOR (ETH)", derivationPath: "m/44'/60'/0'/0"),
        WalletType(name: "Digital Bitbox", derivationPath: "m/44'/60'/0'/0"),
        WalletType(name: "Exodus", derivationPath: "m/44'/60'/0'/0"),
        WalletType(name: "Jaxx", derivationPath: "m/44'/60'/0'/0"),
        WalletType(name: "Ledger (ETH)", derivationPath: "m/44'/60'/0'"),
        WalletType(name: "TREZOR (ETC)", derivationPath: "m/44'/61'/0'/0"),
        WalletType(name: "Ledger (ETC)", derivationPath: "m/44'/60'/160720'/0'"),
        WalletType(name: "SingularDTV", derivationPath: "m/0'/0'/0'"),
        WalletType(name: "Network: Testnets", derivationPath: "m/44'/1'/0'/0"),
        WalletType(name: "Network: Expanse", derivationPath: "m/44'/40'/0'/0"),
        WalletType(name: "Network: Ubiq", derivationPath: "m/44'/108'/0'/0"),
        WalletType(name: "Network: Ellaism", derivationPath: "m/44'/163'/0'/0")
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
        
        importWalletButton.setTitle(NSLocalizedString("Select Your Wallet Type", comment: ""), for: .normal)
        importWalletButton.titleLabel?.font = FontConfigManager.shared.getLabelSCFont(size: 14, type: "Medium")
        importWalletButton.setTitleColor(UIColor.init(rgba: "#4A5668"), for: .normal)
        importWalletButton.setTitleColor(UIColor.init(rgba: "#4A5668").withAlphaComponent(0.7), for: .highlighted)
        importWalletButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        
        seperateLine.backgroundColor = UIColor.init(rgba: "#979797")
        
        imporWalletArrowButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 200, height: 12))
        headerView.backgroundColor = UIColor.clear
        tableView.tableHeaderView = headerView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
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
        // tableView.reloadData()
        dismissViewController()
    }
    
    @objc func dismissViewController() {
        delegate?.selectedImportWalletWalletType(selectedWalletType)
        self.dismiss(animated: true) {
            
        }
    }

}
