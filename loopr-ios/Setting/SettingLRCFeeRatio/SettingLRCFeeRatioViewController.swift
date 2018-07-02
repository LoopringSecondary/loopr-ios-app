//
//  SettingLRCFeeRatioViewController.swift
//  loopr-ios
//
//  Created by xiaoruby on 5/4/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

class SettingLRCFeeRatioViewController: UIViewController {
    
    enum SettingType {
        case lrcFeeRatio
        case marginSplit
    }
    
    var currentSettingType: SettingType
    
    @IBOutlet weak var statusBarBackgroundView: UIView!
    @IBOutlet weak var customizedNavigationBar: UINavigationBar!
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var textFieldBackgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var symbolLabel: UILabel!
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    
    var saveButton: UIButton = UIButton()
    
    convenience init(type: SettingType) {
        self.init(nibName: nil, bundle: nil)
        self.currentSettingType = type
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        currentSettingType = .lrcFeeRatio
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        statusBarBackgroundView.backgroundColor = GlobalPicker.themeColor
        
        typeLabel.font = FontConfigManager.shared.getLabelSCFont(size: 14)
        typeLabel.textColor = UIColor.init(rgba: "#4A5668")
        
        textFieldBackgroundView.layer.borderColor = UIColor.init(rgba: "#E5E7ED").cgColor
        textFieldBackgroundView.layer.borderWidth = 1.0
        textFieldBackgroundView.layer.cornerRadius = 7.5
        textFieldBackgroundView.clipsToBounds = true
        
        textField.font = FontConfigManager.shared.getLabelSCFont(size: 16)
        textField.tintColor = UIColor.init(rgba: "#4A5668")
        textField.textColor = UIColor.init(rgba: "#4A5668")

        symbolLabel.font = FontConfigManager.shared.getLabelSCFont(size: 14)
        symbolLabel.textColor = UIColor.init(rgba: "#4A5668")

        slider.isContinuous = true
        slider.tintColor = GlobalPicker.themeColor
        slider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
        view.addSubview(slider)

        minLabel.font = FontConfigManager.shared.getLabelSCFont()
        view.addSubview(minLabel)
        
        maxLabel.textAlignment = .right
        maxLabel.font = FontConfigManager.shared.getLabelSCFont()
        view.addSubview(maxLabel)
        
        /*
        saveButton.setupRoundBlack()
        saveButton.setTitle(LocalizedString("Save", comment: ""), for: .normal)
        saveButton.addTarget(self, action: #selector(pressedSaveButton), for: .touchUpInside)
        view.addSubview(saveButton)
        */
        
        switch currentSettingType {
        case .lrcFeeRatio:
            typeLabel.text = LocalizedString("LRC Fee Ratio", comment: "")
            textField.text = "\(Int(SettingDataManager.shared.getLrcFeeRatio() * 1000))"
            symbolLabel.text = NumberFormatter().perMillSymbol
            slider.minimumValue = 1
            slider.maximumValue = 50
            slider.value = Float(SettingDataManager.shared.getLrcFeeRatio() * 1000.0)
            minLabel.text = LocalizedString("Slow", comment: "")
            maxLabel.text = LocalizedString("Fast", comment: "")
        case .marginSplit:
            typeLabel.text = LocalizedString("Margin Split", comment: "")
            textField.text = "\(Int(SettingDataManager.shared.getMarginSplit()*100))"
            symbolLabel.text = NumberFormatter().percentSymbol
            slider.minimumValue = 0
            slider.maximumValue = 100
            slider.value = Float(SettingDataManager.shared.getMarginSplit() * 100.0)
            minLabel.text = "0%"
            maxLabel.text = "100%"
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        let navigationTitle: String
        switch currentSettingType {
        case .lrcFeeRatio:
            navigationTitle = LocalizedString("LRC Fee Ratio", comment: "")
        case .marginSplit:
            navigationTitle = LocalizedString("Margin Split", comment: "")
        }
        setBackButtonAndUpdateTitle(customizedNavigationBar: customizedNavigationBar, title: navigationTitle)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    // To avoid gesture conflicts in swiping to back and UISlider
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view != nil && touch.view!.isKind(of: UISlider.self) {
            return false
        }
        return true
    }

    @objc func sliderValueDidChange(_ sender: UISlider!) {
        switch currentSettingType {
        case .lrcFeeRatio:
            let step: Float = 1
            let roundedStepValue = Int(round(sender.value / step))
            let perMillSymbol = NumberFormatter().perMillSymbol!
            // typeLabel.text = "\(roundedStepValue)\(perMillSymbol)"
            textField.text = "\(roundedStepValue)"
        case .marginSplit:
            let step: Float = 1
            let roundedStepValue = Int(round(sender.value / step))
            // currentValueLabel.text = LocalizedString("Margin Split", comment: "") + ": \(roundedStepValue)" + NumberFormatter().percentSymbol
            textField.text = "\(roundedStepValue)"
        }
    }

    @objc func pressedSaveButton(_ sender: Any) {
        switch currentSettingType {
        case .lrcFeeRatio:
            let step: Float = 1
            let newValue = Double(round(slider.value / step)) / 1000.0
            SettingDataManager.shared.setLrcFeeRatio(newValue)
            self.navigationController?.popViewController(animated: true)
        case .marginSplit:
            let step: Float = 1
            let newValue = Double(round(slider.value / step)) / 100.0
            SettingDataManager.shared.setMarginSplit(newValue)
            self.navigationController?.popViewController(animated: true)
        }
    }

}
