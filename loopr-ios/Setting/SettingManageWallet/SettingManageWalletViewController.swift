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

        createButton.setTitle(NSLocalizedString("Generate Wallet", comment: ""), for: .normal)
        createButton.setTitleColor(UIColor.init(rgba: "#4A5668"), for: .normal)
        createButton.titleLabel?.font = FontConfigManager.shared.getLabelSCFont(size: 16, type: "Medium")
        createButton.addTarget(self, action: #selector(pressedCreateButton(_:)), for: UIControlEvents.touchUpInside)
        createButton.layer.shadowColor = UIColor.init(rgba: "#939BB1").cgColor
        createButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        createButton.layer.masksToBounds = false

        importButton.setTitle(NSLocalizedString("Import Wallet", comment: ""), for: .normal)
        importButton.setTitleColor(UIColor.white, for: .normal)
        importButton.titleLabel?.font = FontConfigManager.shared.getLabelSCFont(size: 16, type: "Medium")
        importButton.addTarget(self, action: #selector(pressedImportButton(_:)), for: UIControlEvents.touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        setBackButtonAndUpdateTitle(customizedNavigationBar: customizedNavigationBar, title: NSLocalizedString("Manage Wallet", comment: ""))
        
        // Reload data if the data is updated.
        tableView.reloadData()
        
        let shadowSize: CGFloat = 1.0
        let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2, y: -shadowSize / 2, width: self.createButton.frame.size.width + shadowSize, height: self.createButton.frame.size.height + shadowSize))
        self.createButton.layer.masksToBounds = false
        self.createButton.layer.shadowColor = UIColor.init(rgba: "#939BB1").cgColor
        self.createButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.createButton.layer.shadowOpacity = 0.5
        self.createButton.layer.shadowPath = shadowPath.cgPath
        createButton.setBackgroundColor(UIColor.white, for: .normal)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
