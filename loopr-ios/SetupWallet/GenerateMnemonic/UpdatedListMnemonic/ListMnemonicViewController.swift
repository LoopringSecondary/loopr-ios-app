//
//  ListMnemonicViewController.swift
//  loopr-ios
//
//  Created by xiaoruby on 6/20/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

class ListMnemonicViewController: UIViewController {

    var isCreatingWalletMode: Bool = true
    var isExportingWalletMode: Bool = false
    var wallet: AppWallet?
    
    var mnemonics: [String] = []
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var skipMnemonicButton: UIButton!
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var startInfolbel: UILabel!
    @IBOutlet weak var subStartInfoImageView: UIImageView!
    @IBOutlet weak var subStartInfoLabel: UILabel!
    
    var mnemonicCollectionViewController0: MnemonicCollectionViewController!
    
    var collectionViewY: CGFloat = 200
    var collectionViewWidth: CGFloat = 200
    var collectionViewHeight: CGFloat = 220
    
    private let originY: CGFloat = 30
    private let padding: CGFloat = 15
    private let buttonPaddingY: CGFloat = 40
    
    private var firstAppear = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Add swipe to go-back feature back which is a system default gesture
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self

        if isCreatingWalletMode {
            mnemonics = GenerateWalletDataManager.shared.getMnemonics()
        } else {
            mnemonics = wallet?.mnemonics ?? []
        }
        
        nextButton.addTarget(self, action: #selector(pressedNextButton), for: .touchUpInside)
        if isExportingWalletMode && wallet!.isVerified {
            nextButton.isHidden = true
        }
        
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        skipMnemonicButton.addTarget(self, action: #selector(pressedSkipButton), for: .touchUpInside)
        skipMnemonicButton.title = LocalizedString("Skip Verification", comment: "Go to VerifyMnemonicViewController")
        skipMnemonicButton.titleLabel?.font = FontConfigManager.shared.getLabelSCFont(size: 12)
        skipMnemonicButton.setTitleColor(UIColor.init(rgba: "#F2F5F7"), for: .normal)
        if isCreatingWalletMode {
            skipMnemonicButton.isHidden = false
        } else {
            skipMnemonicButton.isHidden = true
        }

        startInfolbel.font = UIFont.init(name: "Futura-Bold", size: 31)
        subStartInfoLabel.font = FontConfigManager.shared.getLabelSCFont(size: 18)
        subStartInfoLabel.textColor = UIColor.white
        
        if isCreatingWalletMode {
            startInfolbel.text = "Great, Go Ahead"
            subStartInfoImageView.isHidden = false
            subStartInfoLabel.isHidden = true
        } else {
            startInfolbel.text = "Backup help word"
            subStartInfoImageView.isHidden = true
            subStartInfoLabel.isHidden = false
            subStartInfoLabel.text = LocalizedString("Backup Mnemonic", comment: "")
        }
        
        infoLabel.font = FontConfigManager.shared.getLabelSCFont(size: 12)
        infoLabel.textColor = UIColor.tokenestTip
        infoLabel.numberOfLines = 3
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.init(rgba: "#4C5669"),
                          NSAttributedStringKey.font: FontConfigManager.shared.getLabelSCFont(size: 12, type: "Medium")]
        let infoString = "将助记词按顺序记录到本子上，千万不要截图或保存到互联网上。\n这对您的账户安全至关重要，一旦丢失无法恢复！"
        let attr = infoString.higlighted(words: ["按顺序记录", "千万不要截图或保存到互联网上"], attributes: attributes)

        // let paragraphStyle = NSMutableParagraphStyle()
        // paragraphStyle.lineSpacing = 4
        // attr.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attr.length))
        infoLabel.attributedText = attr

        // Setup UI
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width

        collectionViewWidth = screenWidth - 48 - 30
        // Need to update the height for different sizes of devices.
        collectionViewHeight = 7*MnemonicCollectionViewCell.getHeight() + 2*padding
        collectionViewY = 360
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: (collectionViewWidth)/2-8, height: MnemonicCollectionViewCell.getHeight())
        flowLayout.scrollDirection = .vertical
        
        mnemonicCollectionViewController0 = MnemonicCollectionViewController(collectionViewLayout: flowLayout)
        // assign first 12 words
        mnemonicCollectionViewController0.mnemonics = mnemonics
        mnemonicCollectionViewController0.view.isHidden = false
        mnemonicCollectionViewController0.view.frame = CGRect(x: 48, y: collectionViewY, width: collectionViewWidth, height: collectionViewHeight)
        view.addSubview(mnemonicCollectionViewController0.view)
        addChildViewController(mnemonicCollectionViewController0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // CollectionView won't be layout correctly in viewDidLoad()
        // https://stackoverflow.com/questions/12927027/uicollectionview-flowlayout-not-wrapping-cells-correctly-ios
        // If you want to improve this part, please submit a PR to review
        if firstAppear {
            self.mnemonicCollectionViewController0.view.frame = CGRect(x: 48, y: collectionViewY, width: self.collectionViewWidth, height: self.collectionViewHeight)
            mnemonicCollectionViewController0.collectionView?.collectionViewLayout.invalidateLayout()
            
            firstAppear = false
        }
    }
    
    @objc func pressedNextButton(_ sender: Any) {
        print("pressedNextButton")
        let viewController = UpdatedVerifyMnemonicViewController()
        if !isCreatingWalletMode {
            viewController.isCreatingWalletMode = false
            viewController.wallet = wallet
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    @objc func backButtonPressed(_ sender: Any) {
        print("backButtonPressed")
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func pressedSkipButton(_ sender: Any) {
        print("pressedSkipButton")
        if isCreatingWalletMode {
            exit()
        }
    }
    
    func exit() {
        let header = LocalizedString("Create_used_in_creating_wallet", comment: "used in creating wallet")
        let footer = LocalizedString("successfully_used_in_creating_wallet", comment: "used in creating wallet")
        let attributedString = NSAttributedString(string: header + " " + "\(GenerateWalletDataManager.shared.walletName)" + " " + footer, attributes: [
            NSAttributedStringKey.font: UIFont.init(name: FontConfigManager.shared.getMedium(), size: 17) ?? UIFont.systemFont(ofSize: 17),
            NSAttributedStringKey.foregroundColor: UIColor.init(rgba: "#030303")
            ])
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alertController.setValue(attributedString, forKey: "attributedMessage")
        
        let backAction = UIAlertAction(title: LocalizedString("Back", comment: ""), style: .default, handler: { _ in
            alertController.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(backAction)
        
        let confirmAction = UIAlertAction(title: LocalizedString("Enter Wallet", comment: ""), style: .default, handler: { _ in
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
