//
//  SendResultViewController.swift
//  loopr-ios
//
//  Created by 王忱 on 2018/6/24.
//  Copyright © 2018年 Loopring. All rights reserved.
//

import UIKit

//statusBarBackgroundView: UIView!
//@IBOutlet weak var customizedNavigationBar: UINavigationBar!

class SendResultViewController: UIViewController {

    @IBOutlet weak var statusBarBackgroundView: UIView!
    @IBOutlet weak var customNavBar: UINavigationBar!
    @IBOutlet weak var resultImageVIew: UIImageView!
    @IBOutlet weak var resultTipLabel: UILabel!
    @IBOutlet weak var failReasonLabel: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    var asset: Asset!
    var type: String!
    var errorMessage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        statusBarBackgroundView.backgroundColor = GlobalPicker.themeColor
        self.navigationItem.setHidesBackButton(true, animated: true)
        setBackButtonAndUpdateTitle(customizedNavigationBar: customNavBar, title: "\(type!)")
        if let errorMessage = self.errorMessage {
            resultTipLabel.text = "\(self.type!)失败"
            resultImageVIew.image = #imageLiteral(resourceName: "Tokenest-failed")
            detailButton.isHidden = true
            failReasonLabel.isHidden = false
            failReasonLabel.text = errorMessage
        } else {
            resultTipLabel.text = "\(self.type!)成功"
            detailButton.layer.shadowRadius = 4
            detailButton.layer.shadowColor = UIColor.tokenestBackground.cgColor
            detailButton.layer.shadowOffset = CGSize(width: 4, height: 4)
            detailButton.clipsToBounds = false
        }
        doneButton.layer.shadowRadius = 4
        doneButton.layer.shadowColor = UIColor.tokenestBackground.cgColor
        doneButton.layer.shadowOffset = CGSize(width: 4, height: 4)
        doneButton.clipsToBounds = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    @IBAction func pressedDetailButton(_ sender: UIButton) {
        let vc = AssetDetailViewController()
        vc.asset = self.asset
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func pressedDoneButton(_ sender: UIButton) {
        self.navigationController!.popToRootViewController(animated: true)
    }
}
