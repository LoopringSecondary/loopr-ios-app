//
//  ListMnemonicViewController.swift
//  loopr-ios
//
//  Created by xiaoruby on 6/20/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

class ListMnemonicViewController: UIViewController {

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!

    @IBOutlet weak var startInfolbel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Add swipe to go-back feature back which is a system default gesture
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        nextButton.addTarget(self, action: #selector(pressedNextButton), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)

        startInfolbel.font = UIFont.init(name: "Futura-Bold", size: 31)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func pressedNextButton(_ sender: Any) {
        print("pressedNextButton")
        let viewController = UpdatedVerifyMnemonicViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    @objc func backButtonPressed(_ sender: Any) {
        print("backButtonPressed")
        self.navigationController?.popViewController(animated: true)
    }

}
