//
//  SettingManageWalletViewController.swift
//  loopr-ios
//
//  Created by xiaoruby on 4/6/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

class SettingManageWalletViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var statusBarBackgroundView: UIView!
    @IBOutlet weak var customizedNavigationBar: UINavigationBar!
    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var importButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        statusBarBackgroundView.backgroundColor = GlobalPicker.themeColor

        view.backgroundColor = UIColor.init(rgba: "#F3F6F8")
        tableView.backgroundColor = UIColor.init(rgba: "#F3F6F8")

        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 200, height: 8))
        headerView.backgroundColor = UIColor.init(rgba: "#F3F6F8")
        tableView.tableHeaderView = headerView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()

        createButton.setTitle(LocalizedString("Generate Wallet", comment: ""), for: .normal)
        createButton.setTitleColor(UIColor.init(rgba: "#4A5668"), for: .normal)
        createButton.titleLabel?.font = FontConfigManager.shared.getLabelSCFont(size: 16, type: "Medium")
        createButton.addTarget(self, action: #selector(pressedCreateButton(_:)), for: UIControlEvents.touchUpInside)
        createButton.layer.borderWidth = 0.5
        createButton.layer.borderColor = UIColor.init(rgba: "#E5E7ED").cgColor

        importButton.setTitle(LocalizedString("Import Wallet", comment: ""), for: .normal)
        importButton.setTitleColor(UIColor.white, for: .normal)
        importButton.titleLabel?.font = FontConfigManager.shared.getLabelSCFont(size: 16, type: "Medium")
        importButton.addTarget(self, action: #selector(pressedImportButton(_:)), for: UIControlEvents.touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(currentAppWalletSwitchedReceivedNotification), name: .currentAppWalletSwitched, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        setBackButtonAndUpdateTitle(customizedNavigationBar: customizedNavigationBar, title: LocalizedString("Manage Wallet", comment: ""))
        
        // Reload data if the data is updated.
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func currentAppWalletSwitchedReceivedNotification() {
        tableView.reloadData()
    }
    
    @objc func pressedCreateButton(_ sender: UIButton) {
        let viewController = UpdatedGenerateWalletEnterNameAndPasswordViewController()
        viewController.hidesBottomBarWhenPushed = true
        viewController.isPushedInParentViewController = false
        viewController.modalPresentationStyle = .overFullScreen
        
        let newNavigationController = UINavigationController()
        newNavigationController.modalPresentationStyle = .overFullScreen
        newNavigationController.setViewControllers([viewController], animated: false)
        self.navigationController?.present(newNavigationController, animated: true, completion: {
            
        })
    }
    
    @objc func pressedImportButton(_ sender: UIButton) {
        let viewController = UpdatedUnlockWalletViewController()
        viewController.hidesBottomBarWhenPushed = true
        viewController.isPushedInParentViewController = false
        viewController.modalPresentationStyle = .overFullScreen
        
        let newNavigationController = UINavigationController()
        newNavigationController.modalPresentationStyle = .overFullScreen
        newNavigationController.setViewControllers([viewController], animated: false)
        self.navigationController?.present(newNavigationController, animated: true, completion: {
            
        })
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppWalletDataManager.shared.getWallets().count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SettingManageWalletTableViewCell.getHeight()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: SettingManageWalletTableViewCell.getCellIdentifier()) as? SettingManageWalletTableViewCell
        if cell == nil {
            let nib = Bundle.main.loadNibNamed("SettingManageWalletTableViewCell", owner: self, options: nil)
            cell = nib![0] as? SettingManageWalletTableViewCell
        }
        
        // Configure the cell...
        cell?.wallet = AppWalletDataManager.shared.getWallets()[indexPath.row]
        cell?.update()
        cell?.pressedNeedVerifiedButtonClosure = {
            let viewController = ListMnemonicViewController()
            viewController.isCreatingWalletMode = false
            viewController.wallet = AppWalletDataManager.shared.getWallets()[indexPath.row]
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewController = SettingWalletDetailViewController()
        viewController.appWallet = AppWalletDataManager.shared.getWallets()[indexPath.row]
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
