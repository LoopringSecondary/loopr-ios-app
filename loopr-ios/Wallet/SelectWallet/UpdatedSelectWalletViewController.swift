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
        
        createButton.setTitle(NSLocalizedString("Generate Wallet", comment: ""), for: .normal)
        createButton.setupRoundPurple(height: 48, font: UIFont.init(name: FontConfigManager.shared.getRegular(), size: 16))
        createButton.addTarget(self, action: #selector(pressedCreateButton(_:)), for: UIControlEvents.touchUpInside)
        
        importButton.setTitle(NSLocalizedString("Import Wallet", comment: ""), for: .normal)
        importButton.setupRoundPurpleOutline(height: 48, font: UIFont.init(name: FontConfigManager.shared.getRegular(), size: 16))
        importButton.addTarget(self, action: #selector(pressedImportButton(_:)), for: UIControlEvents.touchUpInside)

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
        self.navigationController?.present(viewController, animated: true, completion: {
            
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

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: SelectWalletTableViewCell.getCellIdentifier()) as? SelectWalletTableViewCell
        if cell == nil {
            let nib = Bundle.main.loadNibNamed("SelectWalletTableViewCell", owner: self, options: nil)
            cell = nib![0] as? SelectWalletTableViewCell
        }
        
        // Configure the cell...
        cell?.wallet = AppWalletDataManager.shared.getWallets()[indexPath.row]
        cell?.update()
        return cell!
    }
}
