//
//  UpdatedSetupViewController.swift
//  loopr-ios
//
//  Created by xiaoruby on 6/17/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

class UpdatedSetupViewController: UIViewController {

    var isCreatingFirstWallet: Bool = true
    
    var backgrondImageView = UIImageView()
    var unlockWalletButton = UIButton()
    var unlockWalletIconButton = UIButton()
    var generateWalletButton = UIButton()
    var generateWalletIconButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
        // self.navigationController?.navigationBar.alpha = 0
        
        let screenSize: CGRect = UIScreen.main.bounds
        backgrondImageView.frame = screenSize
        backgrondImageView.backgroundColor = GlobalPicker.themeColor
        backgrondImageView.isUserInteractionEnabled = true
        view.addSubview(backgrondImageView)
        
        unlockWalletButton.title = NSLocalizedString("Import", comment: "")
        unlockWalletButton.setTitleColor(UIColor.white, for: .normal)
        unlockWalletButton.addTarget(self, action: #selector(unlockWalletButtonPressed), for: .touchUpInside)
        backgrondImageView.addSubview(unlockWalletButton)
        
        generateWalletButton.title = NSLocalizedString("Create", comment: "")
        generateWalletButton.setTitleColor(UIColor.white, for: .normal)
        generateWalletButton.addTarget(self, action: #selector(generateWalletButtonPressed), for: .touchUpInside)
        backgrondImageView.addSubview(generateWalletButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true

        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let bottomPadding: CGFloat = UIDevice.current.iPhoneX ? 30 : 0
        
        let frameY: CGFloat = screenHeight - bottomPadding - 47 - 63
        let titleButtonWidth: CGFloat = 60
        
        unlockWalletButton.frame = CGRect(x: 30, y: frameY, width: titleButtonWidth, height: 28)

        generateWalletButton.frame = CGRect(x: screenWidth - 30 - titleButtonWidth, y: frameY, width: titleButtonWidth, height: 28)
    }

    @objc func unlockWalletButtonPressed(_ sender: Any) {
        print("unlockWalletButtonPressed")
        let viewController = UnlockWalletViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func generateWalletButtonPressed(_ sender: Any) {
        print("generateWalletButtonPressed")
        let viewController = GenerateWalletEnterNameAndPasswordViewController(nibName: nil, bundle: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
    }

}
