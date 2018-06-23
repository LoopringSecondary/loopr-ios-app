//
//  UpdatedSelectWalletViewController.swift
//  loopr-ios
//
//  Created by xiaoruby on 6/21/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

protocol UpdatedSelectWalletViewControllerDelegate: class {
    func pressedCreateButtonInUpdatedSelectWalletViewController()
}

class UpdatedSelectWalletViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: UpdatedSelectWalletViewControllerDelegate?
    
    @IBOutlet weak var walletTableView: UITableView!
    
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var importButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = NSLocalizedString("Wallet", comment: "")
        
        walletTableView.delegate = self
        walletTableView.dataSource = self
        walletTableView.estimatedRowHeight = 2.0
        walletTableView.separatorStyle = .none
        walletTableView.rowHeight = UITableViewAutomaticDimension
        walletTableView.tableFooterView = UIView()
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 200, height: 4))
        walletTableView.tableHeaderView = headerView
        
        createButton.setTitle(NSLocalizedString("Generate Wallet", comment: ""), for: .normal)
        createButton.setupRoundPurple(height: 48, font: UIFont.init(name: FontConfigManager.shared.getRegular(), size: 16))
        createButton.addTarget(self, action: #selector(pressedCreateButton(_:)), for: UIControlEvents.touchUpInside)
        
        importButton.setTitle(NSLocalizedString("Import Wallet", comment: ""), for: .normal)
        importButton.setupRoundPurpleOutline(height: 48, font: UIFont.init(name: FontConfigManager.shared.getRegular(), size: 16))
        importButton.addTarget(self, action: #selector(pressedImportButton(_:)), for: UIControlEvents.touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        walletTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func pressedCreateButton(_ sender: UIButton) {
        delegate?.pressedCreateButtonInUpdatedSelectWalletViewController()
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
        let viewController = UnlockWalletViewController()
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppWalletDataManager.shared.getWallets().count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UpdatedSelectWalletTableViewCell.getHeight()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: UpdatedSelectWalletTableViewCell.getCellIdentifier()) as? UpdatedSelectWalletTableViewCell
        if cell == nil {
            let nib = Bundle.main.loadNibNamed("UpdatedSelectWalletTableViewCell", owner: self, options: nil)
            cell = nib![0] as? UpdatedSelectWalletTableViewCell
        }
        
        // Configure the cell...
        cell?.wallet = AppWalletDataManager.shared.getWallets()[indexPath.row]
        cell?.update()
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let appWallet = AppWalletDataManager.shared.getWallets()[indexPath.row]
        if appWallet.address != CurrentAppWalletDataManager.shared.getCurrentAppWallet()!.address {
            let alertController = UIAlertController(title: NSLocalizedString("Choose Wallet", comment: "") + ": \(appWallet.name)",
                message: nil,
                preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .default, handler: { _ in
                CurrentAppWalletDataManager.shared.setCurrentAppWallet(appWallet)
                self.walletTableView.reloadData()
            })
            alertController.addAction(defaultAction)
            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { _ in
            })
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }

}
