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
    var userInputMnemonics: [String] = []

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
        clearButton.addTarget(self, action: #selector(pressedClearButton), for: .touchUpInside)
        
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
    
    @objc func backButtonPressed(_ sender: Any) {
        print("backButtonPressed")
        self.navigationController?.popViewController(animated: true)
    }

    @objc func pressedClearButton(_ sender: Any) {
        print("pressedClearButton")
        userInputMnemonics = []
        mnemonicTextVeiw.text = ""
        for tagView in mnemonicWordTagView.tagViews {
            tagView.isSelected = false
        }
    }
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
        tagView.isSelected = true
        
        let copyMnemonicText = mnemonicTextVeiw.text ?? ""
        mnemonicTextVeiw.text = copyMnemonicText + "  " + title
    }
    
    @objc func pressedCompleteButton(_ sender: Any) {
        print("pressedCompleteButton")
        if GenerateWalletDataManager.shared.verify(userInputMnemonics: userInputMnemonics) {
            // Store the new wallet to the local storage and exit the view controller.
            exit()
        } else {
            print("User input Mnemonic doesn't match")
            var title = ""
            if GenerateWalletDataManager.shared.getUserInputMnemonics().count == 0 {
                title = NSLocalizedString("Please click words in order to verify your mnemonic.", comment: "")
            } else {
                title = NSLocalizedString("Mnemonic doesn't match. Please verify again.", comment: "")
            }
            
            // Reset
            GenerateWalletDataManager.shared.clearUserInputMnemonic()
            
            let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.userInputMnemonics = []
                self.mnemonicTextVeiw.text = ""
                for tagView in self.mnemonicWordTagView.tagViews {
                    tagView.isSelected = false
                }
            })
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }

    func exit() {
        let header = NSLocalizedString("Create_used_in_creating_wallet", comment: "used in creating wallet")
        let footer = NSLocalizedString("successfully_used_in_creating_wallet", comment: "used in creating wallet")
        let attributedString = NSAttributedString(string: header + " " + "\(GenerateWalletDataManager.shared.walletName)" + " " + footer, attributes: [
            NSAttributedStringKey.font: UIFont.init(name: FontConfigManager.shared.getMedium(), size: 17) ?? UIFont.systemFont(ofSize: 17),
            NSAttributedStringKey.foregroundColor: UIColor.init(rgba: "#030303")
            ])
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alertController.setValue(attributedString, forKey: "attributedMessage")
        let confirmAction = UIAlertAction(title: NSLocalizedString("Enter Wallet", comment: ""), style: .default, handler: { _ in
            GenerateWalletDataManager.shared.complete(completion: {(appWallet, error) in
                if error == nil {
                    self.dismissGenerateWallet()
                } else if error == .duplicatedAddress {
                    self.alertForDuplicatedAddress()
                } else {
                    self.alertForError()
                }
            })
        })
        alertController.addAction(confirmAction)
        
        // Show the UIAlertController
        self.present(alertController, animated: true, completion: nil)
    }
    
    func dismissGenerateWallet() {
        if SetupDataManager.shared.hasPresented {
            self.dismiss(animated: true, completion: {
                
            })
        } else {
            SetupDataManager.shared.hasPresented = true
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.window?.rootViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController()
        }
    }
}

