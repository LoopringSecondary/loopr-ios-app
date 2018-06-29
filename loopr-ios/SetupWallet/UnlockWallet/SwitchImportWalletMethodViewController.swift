//
//  SwitchImportWalletMethodViewController.swift
//  loopr-ios
//
//  Created by xiaoruby on 6/24/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

protocol SwitchImportWalletMethodViewControllerDelegate: class {
    func selectedImportWalletMethod(_ selectedImportMethod: QRCodeMethod?)
}

class SwitchImportWalletMethodViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    weak var delegate: SwitchImportWalletMethodViewControllerDelegate?
    
    private var types: [QRCodeMethod] = [.importUsingKeystore, .importUsingPrivateKey, .importUsingMnemonic]
    var currentImportMethod: QRCodeMethod = .importUsingKeystore
    var selectedImportMethod: QRCodeMethod?
    
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
        
        importWalletButton.setTitle(NSLocalizedString("Import Wallet", comment: ""), for: .normal)
        importWalletButton.titleLabel?.font = FontConfigManager.shared.getLabelSCFont(size: 16, type: "Medium")
        importWalletButton.setTitleColor(UIColor.init(rgba: "#4A5668"), for: .normal)
        importWalletButton.setTitleColor(UIColor.init(rgba: "#4A5668").withAlphaComponent(0.7), for: .highlighted)
        importWalletButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        importWalletButton.isEnabled = false

        seperateLine.backgroundColor = UIColor.init(rgba: "#E5E7ED")
        
        imporWalletArrowButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 200, height: 12))
        headerView.backgroundColor = UIColor.clear
        tableView.tableHeaderView = headerView
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
        return types.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 47
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "SwitchImportWalletMethodTableViewCell")
        cell.selectionStyle = .none
        cell.textLabel?.textAlignment = .center

        if types[indexPath.row] == .importUsingKeystore {
            cell.textLabel?.text = types[indexPath.row].description + " " + NSLocalizedString("File", comment: "")
        } else {
            cell.textLabel?.text = types[indexPath.row].description
        }

        cell.textLabel?.font = FontConfigManager.shared.getLabelENFont(size: 16)
        if selectedImportMethod == nil {
            if currentImportMethod == types[indexPath.row] {
                cell.textLabel?.textColor = GlobalPicker.themeColor
            } else {
                cell.textLabel?.textColor = UIColor.init(rgba: "#32384C")
            }
        } else {
            if selectedImportMethod! == types[indexPath.row] {
                cell.textLabel?.textColor = GlobalPicker.themeColor
            } else {
                cell.textLabel?.textColor = UIColor.init(rgba: "#32384C")
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedImportMethod = types[indexPath.row]
        // tableView.reloadData()
        dismissViewController()
    }
    
    @objc func dismissViewController() {
        delegate?.selectedImportWalletMethod(selectedImportMethod)
        self.dismiss(animated: true) {
            
        }
    }
}
