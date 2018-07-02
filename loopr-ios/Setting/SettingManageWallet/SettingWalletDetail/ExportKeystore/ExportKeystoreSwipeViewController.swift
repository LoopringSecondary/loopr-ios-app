//
//  ExportKeystoreSwipeViewController.swift
//  loopr-ios
//
//  Created by xiaoruby on 4/7/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

class ExportKeystoreSwipeViewController: SwipeViewController {
    
    private var keystore: String = ""

    private var viewControllers: [UIViewController] = []
    var options = SwipeViewOptions()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = LocalizedString("Export Keystore", comment: "")
        setBackButton()

        options.swipeTabView.height = 44
        options.swipeTabView.underlineView.height = 0
        
        options.swipeTabView.style = .segmented
        options.swipeTabView.itemView.font = FontConfigManager.shared.getLabelSCFont(size: 17, type: "Medium")
        
        swipeView.reloadData(options: options)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setKeystore(_ keystore: String) {
        let displayKeystoreViewController = DisplayKeystoreViewController()
        displayKeystoreViewController.keystore = keystore
        
        let displayKeystoreInQRCodeViewController = DisplayKeystoreInQRCodeViewController()
        displayKeystoreInQRCodeViewController.keystore = keystore
        
        viewControllers = [displayKeystoreViewController, displayKeystoreInQRCodeViewController]
        swipeView.reloadData(options: options)
    }

    // MARK: - Delegate
    override func swipeView(_ swipeView: SwipeView, viewWillSetupAt currentIndex: Int) {
        // print("will setup SwipeView")
    }
    
    override func swipeView(_ swipeView: SwipeView, viewDidSetupAt currentIndex: Int) {
        // print("did setup SwipeView")
    }
    
    override func swipeView(_ swipeView: SwipeView, willChangeIndexFrom fromIndex: Int, to toIndex: Int) {
        // print("will change from item \(fromIndex) to item \(toIndex)")
    }
    
    override func swipeView(_ swipeView: SwipeView, didChangeIndexFrom fromIndex: Int, to toIndex: Int) {
        // print("did change from item \(fromIndex) to section \(toIndex)")
    }
    
    // MARK: DataSource
    override func numberOfPages(in swipeView: SwipeView) -> Int {
        return viewControllers.count
    }
    
    override func swipeView(_ swipeView: SwipeView, titleForPageAt index: Int) -> String {
        if index == 0 {
            return LocalizedString("Export_Keystore_in_ExportKeystoreSwipeViewController", comment: "")
        } else {
            return LocalizedString("QR Code", comment: "")
        }
    }
    
    override func swipeView(_ swipeView: SwipeView, viewControllerForPageAt index: Int) -> UIViewController {
        var viewController: UIViewController
        if index == 0 {
            viewController = viewControllers[0]
        } else {
            viewController = viewControllers[1]
        }
        self.addChildViewController(viewController)
        return viewController
    }
}
