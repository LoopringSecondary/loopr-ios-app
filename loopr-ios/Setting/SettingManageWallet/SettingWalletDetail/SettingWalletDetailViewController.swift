//
//  SettingWalletDetailViewController.swift
//  loopr-ios
//
//  Created by xiaoruby on 4/6/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit
import MessageUI

class SettingWalletDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var appWallet: AppWallet!

    @IBOutlet weak var statusBarBackgroundView: UIView!
    @IBOutlet weak var customizedNavigationBar: UINavigationBar!
        
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var deleteWalletButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        statusBarBackgroundView.backgroundColor = GlobalPicker.themeColor

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        deleteWalletButton.setTitle(NSLocalizedString("Delete Wallet", comment: ""), for: .normal)
        deleteWalletButton.setTitleColor(UIColor.init(rgba: "#E83769"), for: .normal)
        deleteWalletButton.setTitleColor(UIColor.init(rgba: "#E83769").withAlphaComponent(0.3), for: .highlighted)
        deleteWalletButton.addTarget(self, action: #selector(pressedDeleteWalletButton(_:)), for: UIControlEvents.touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(appWallet.name)
        setBackButtonAndUpdateTitle(customizedNavigationBar: customizedNavigationBar, title: appWallet.name)
        self.tableView.reloadData()
        
        let shadowSize: CGFloat = 1.0
        let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2,
                                                   y: -shadowSize / 2,
                                                   width: self.deleteWalletButton.frame.size.width + shadowSize,
                                                   height: self.deleteWalletButton.frame.size.height + shadowSize))
        self.deleteWalletButton.layer.masksToBounds = false
        self.deleteWalletButton.layer.shadowColor = UIColor.init(rgba: "#939BB1").cgColor
        self.deleteWalletButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.deleteWalletButton.layer.shadowOpacity = 0.5
        self.deleteWalletButton.layer.shadowPath = shadowPath.cgPath
        deleteWalletButton.setBackgroundColor(UIColor.white, for: .normal)
        
        // TODO: not sure about the background color
        deleteWalletButton.setBackgroundColor(UIColor.white, for: .highlighted)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func pressedDeleteWalletButton(_ sender: UIButton) {
        presentAlertControllerToConfirmClearRecords()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return getNumberOfRowsInWalletSection()
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SettingWalletDetailTableViewCell.getHeight()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getTableViewCell(cellForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let cell = tableView.cellForRow(at: indexPath) as? SettingWalletDetailTableViewCell else {
            return
        }
        switch cell.contentType {
        case .walletName:
            let viewController = SettingChangeWalletNameViewController()
            viewController.appWallet = appWallet
            self.navigationController?.pushViewController(viewController, animated: true)
        case .backupMnemonic:
            let viewController = ExportMnemonicViewController()
            viewController.appWallet = appWallet
            self.navigationController?.pushViewController(viewController, animated: true)
        case .exportPrivateKey:
            let viewController = DisplayPrivateKeyViewController()
            viewController.appWallet = appWallet
            self.navigationController?.pushViewController(viewController, animated: true)
        case .exportKeystore:
            let viewController = ExportKeystoreEnterPasswordViewController()
            viewController.appWallet = appWallet
            self.navigationController?.pushViewController(viewController, animated: true)
        case .clearRecords:
            presentAlertControllerToConfirmClearRecords()
        default:
            return
        }
    }

    func presentAlertControllerToConfirmClearRecords() {
        let header = NSLocalizedString("You are going to clear records of", comment: "")
        let footer = NSLocalizedString("on this device.", comment: "")
        let alertController = UIAlertController(title: "\(header) \(appWallet.name) \(footer)", message: nil, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .default, handler: { _ in
            AppWalletDataManager.shared.logout(appWallet: self.appWallet)
            if AppWalletDataManager.shared.getWallets().isEmpty {
                self.navigationToSetupNavigationController()
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        })
        alertController.addAction(defaultAction)
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { _ in
        })
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func navigationToSetupNavigationController() {
        let alertController = UIAlertController(title: "No wallet is found in the device. Navigate to the wallet creation view.", message: nil, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
            SetupDataManager.shared.hasPresented = false
            UIApplication.shared.keyWindow?.rootViewController = SetupNavigationController(nibName: nil, bundle: nil)
        })
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }

}
