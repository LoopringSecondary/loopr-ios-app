//
//  UpdatedSetupViewController.swift
//  loopr-ios
//
//  Created by xiaoruby on 6/17/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

class UpdatedSetupViewController: UIViewController {
    
    @IBOutlet weak var unlockWalletButton: UIButton!
    @IBOutlet weak var unlockIconWalletButton: UIButton!
    
    @IBOutlet weak var generateWalletButton: UIButton!
    @IBOutlet weak var generateIconWalletButton: UIButton!
    
    var generateWalletIconButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
        // self.navigationController?.navigationBar.alpha = 0
    
        unlockWalletButton.backgroundColor = UIColor.clear
        unlockWalletButton.title = NSLocalizedString("Import", comment: "")
        unlockWalletButton.setTitleColor(UIColor.white, for: .normal)
        unlockWalletButton.setTitleColor(UIColor.black.withAlphaComponent(0.7), for: .highlighted)
        unlockWalletButton.titleLabel?.font = FontConfigManager.shared.getRegularFont(size: 13)
        unlockWalletButton.addTarget(self, action: #selector(unlockWalletButtonPressed), for: .touchUpInside)
        
        unlockIconWalletButton.addTarget(self, action: #selector(unlockWalletButtonPressed), for: .touchUpInside)
        
        generateWalletButton.backgroundColor = UIColor.clear
        generateWalletButton.title = NSLocalizedString("Create", comment: "")
        generateWalletButton.setTitleColor(UIColor.white, for: .normal)
        generateWalletButton.setTitleColor(UIColor.black.withAlphaComponent(0.7), for: .highlighted)
        generateWalletButton.titleLabel?.font = FontConfigManager.shared.getRegularFont(size: 13)
        generateWalletButton.addTarget(self, action: #selector(generateWalletButtonPressed), for: .touchUpInside)
        
        generateIconWalletButton.addTarget(self, action: #selector(generateWalletButtonPressed), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }

    @objc func unlockWalletButtonPressed(_ sender: Any) {
        print("unlockWalletButtonPressed")
        let viewController = UnlockWalletSwipeViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func generateWalletButtonPressed(_ sender: Any) {
        print("generateWalletButtonPressed")
        let viewController = UpdatedGenerateWalletEnterNameAndPasswordViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }

}
