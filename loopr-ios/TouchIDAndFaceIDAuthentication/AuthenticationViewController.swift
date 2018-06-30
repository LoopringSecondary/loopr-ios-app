//
//  AuthenticationViewController.swift
//  loopr-ios
//
//  Created by xiaoruby on 5/23/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController {

    @IBOutlet weak var unlockAppButton1: UIButton!
    @IBOutlet weak var unlockAppButton2: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("Show AuthenticationViewController")

        unlockAppButton1.addTarget(self, action: #selector(pressedUnlockAppButton), for: .touchUpInside)
        unlockAppButton2.setTitle(LocalizedString("Unlock", comment: ""), for: .normal)
        unlockAppButton2.addTarget(self, action: #selector(pressedUnlockAppButton), for: .touchUpInside)

        self.navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AuthenticationDataManager.shared.authenticate { (error) in
            guard error == nil else { return }
            self.dismiss(animated: true, completion: nil)
        }
    }

    @objc func pressedUnlockAppButton(_ sender: Any) {
        print("pressedUnlockAppButton")
        AuthenticationDataManager.shared.authenticate { (error) in
            guard error == nil else { return }
            self.dismiss(animated: true, completion: nil)
        }
    }
}
