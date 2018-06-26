//
//  MainTabController.swift
//  loopr-ios
//
//  Created by Matthew Cox on 2/3/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit
import ESTabBarController_swift

class MainTabController: ESTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let v1 = WalletNavigationViewController()
        let v2 = MarketNavigationViewController()
        let v3 = TradeNavigationViewController()
        let v4 = H5DexNavigationController()
        let v5 = SettingNavigationViewController()
        
        v1.tabBarItem = ESTabBarItem.init(TabBarItemBouncesContentView(), title: nil, image: UIImage(named: "Tokenest-asset"), selectedImage: UIImage(named: "Tokenest-asset-selected"))
        v2.tabBarItem = ESTabBarItem.init(TabBarItemBouncesContentView(), title: nil, image: UIImage(named: "Tokenest-market"), selectedImage: UIImage(named: "Tokenest-market-selected"))
        v3.tabBarItem = ESTabBarItem.init(TabBarItemBouncesContentView(), title: nil, image: UIImage(named: "Tokenest-orders"), selectedImage: UIImage(named: "Tokenest-orders-selected"))
        v4.tabBarItem = ESTabBarItem.init(TabBarItemBouncesContentView(), title: nil, image: UIImage(named: "Tokenest-orders"), selectedImage: UIImage(named: "Tokenest-orders-selected"))
        v5.tabBarItem = ESTabBarItem.init(TabBarItemBouncesContentView(), title: nil, image: UIImage(named: "Tokenest-settings"), selectedImage: UIImage(named: "Tokenest-settings-selected"))

        viewControllers = [v1, v2, v3, v4, v5]
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
