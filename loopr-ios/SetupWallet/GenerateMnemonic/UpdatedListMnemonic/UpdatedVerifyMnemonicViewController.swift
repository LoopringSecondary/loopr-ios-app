//
//  UpdatedVerifyMnemonicViewController.swift
//  loopr-ios
//
//  Created by xiaoruby on 6/20/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit
import TagListView

class UpdatedVerifyMnemonicViewController: UIViewController, TagListViewDelegate {

    var sortedMnemonics: [String] = []
    
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var startInfolbel: UILabel!
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    
    @IBOutlet weak var mnemonicBackgroundView: UIView!
    
    @IBOutlet weak var mnemonicTextVeiw: UITextView!
    @IBOutlet weak var mnemonicWordTagView: TagListView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        // mnemonics.shuffle()
        sortedMnemonics = GenerateWalletDataManager.shared.getMnemonics()
        sortedMnemonics.sort { (a, b) -> Bool in
            return a < b
        }

        completeButton.addTarget(self, action: #selector(pressedCompleteButton), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        startInfolbel.font = UIFont.init(name: "Futura-Bold", size: 31)

        infoLabel.textColor = UIColor.tokenestTip
        infoLabel.font = FontConfigManager.shared.getLabelSCFont(size: 12)
        infoLabel.numberOfLines = 1
        infoLabel.text = NSLocalizedString("Please click words in order.", comment: "")
        
        clearButton.setTitle(NSLocalizedString("Clear", comment: ""), for: .normal)
        
        mnemonicBackgroundView.cornerRadius = 5
        mnemonicBackgroundView.layer.borderColor = UIColor.init(rgba: "#E5E7ED").cgColor
        mnemonicBackgroundView.layer.borderWidth = 1
        mnemonicBackgroundView.backgroundColor = UIColor.init(rgba: "#F3F6F8")

        mnemonicTextVeiw.font = FontConfigManager.shared.getLabelSCFont(size: 15)
        mnemonicTextVeiw.isUserInteractionEnabled = false
        mnemonicTextVeiw.backgroundColor = UIColor.init(rgba: "#F3F6F8")

        mnemonicWordTagView.addTags(sortedMnemonics)
        mnemonicWordTagView.delegate = self
        mnemonicWordTagView.textFont = FontConfigManager.shared.getLabelSCFont(size: 15)
        mnemonicWordTagView.alignment = .left
        mnemonicWordTagView.textColor = UIColor.init(rgba: "#878FA4")
        
        mnemonicWordTagView.borderWidth = 1
        mnemonicWordTagView.borderColor = UIColor.tokenestBorder
        mnemonicWordTagView.selectedBorderColor = UIColor.clear
        mnemonicWordTagView.cornerRadius = 15
        mnemonicWordTagView.tagBackgroundColor = UIColor.white
        mnemonicWordTagView.tagSelectedBackgroundColor = GlobalPicker.themeColor
        mnemonicWordTagView.paddingX = 16
        mnemonicWordTagView.marginX = 16
        mnemonicWordTagView.paddingY = 8
        mnemonicWordTagView.marginY = 14
        
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

    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
        tagView.isSelected = true
        
        let copyMnemonicText = mnemonicTextVeiw.text ?? ""
        mnemonicTextVeiw.text = copyMnemonicText + "  " + title
    }
}
