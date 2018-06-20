//
//  UpdatedVerifyMnemonicViewController.swift
//  loopr-ios
//
//  Created by xiaoruby on 6/20/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

class UpdatedVerifyMnemonicViewController: UIViewController {

    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var startInfolbel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self

        completeButton.addTarget(self, action: #selector(pressedCompleteButton), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        startInfolbel.font = UIFont.init(name: "Futura-Bold", size: 31)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func pressedCompleteButton(_ sender: Any) {
        print("pressedNextButton")
        // let viewController = UpdatedVerifyMnemonicViewController()
        // self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func backButtonPressed(_ sender: Any) {
        print("backButtonPressed")
        self.navigationController?.popViewController(animated: true)
    }

}
