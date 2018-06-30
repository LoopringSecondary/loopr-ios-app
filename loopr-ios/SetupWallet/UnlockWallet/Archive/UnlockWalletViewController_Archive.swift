//
//  UnlockWalletViewController.swift
//  loopr-ios
//
//  Created by xiaoruby on 6/17/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

class UnlockWalletViewController_Archive: UIViewController {

    @IBOutlet weak var statusBarBackgroundView: UIView!
    @IBOutlet weak var customizedNavigationBar: UINavigationBar!    
    
    var unlockWalletSwipeViewController = UnlockWalletSwipeViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        statusBarBackgroundView.backgroundColor = GlobalPicker.themeColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        setBackButtonAndUpdateTitle(customizedNavigationBar: customizedNavigationBar, title: LocalizedString("Import Wallet", comment: ""))
        
        let screensize: CGRect = self.view.frame
        let screenWidth = screensize.width
        let screenHeight = screensize.height
        
        unlockWalletSwipeViewController.view.frame = CGRect.init(x: 0, y: customizedNavigationBar.frame.maxY, width: screenWidth, height: screenHeight - customizedNavigationBar.frame.maxY)
        view.addSubview(unlockWalletSwipeViewController.view)
        addChildViewController(unlockWalletSwipeViewController)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

}
