//
//  SettingLRCFeeRatioViewController.swift
//  loopr-ios
//
//  Created by xiaoruby on 5/4/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

class SettingLRCFeeRatioViewController: UIViewController {

    @IBOutlet weak var statusBarBackgroundView: UIView!
    @IBOutlet weak var customizedNavigationBar: UINavigationBar!
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var textFieldBackgroundView: UIView!

    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    
    var saveButton: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        statusBarBackgroundView.backgroundColor = GlobalPicker.themeColor
        
        typeLabel.font = FontConfigManager.shared.getLabelENFont()
        typeLabel.text = NSLocalizedString("LRC Fee Ratio", comment: "")
        
        textFieldBackgroundView.layer.borderColor = UIColor.init(rgba: "#E5E7ED").cgColor
        textFieldBackgroundView.layer.borderWidth = 1.0
        textFieldBackgroundView.layer.cornerRadius = 7.5
        textFieldBackgroundView.clipsToBounds = true

        slider.minimumValue = 1
        slider.maximumValue = 50
        slider.value = Float(SettingDataManager.shared.getLrcFeeRatio() * 1000.0)
        
        slider.isContinuous = true
        slider.tintColor = GlobalPicker.themeColor
        slider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
        view.addSubview(slider)

        minLabel.font = FontConfigManager.shared.getLabelENFont()
        minLabel.text = NSLocalizedString("Slow", comment: "")
        view.addSubview(minLabel)
        
        maxLabel.textAlignment = .right
        maxLabel.font = FontConfigManager.shared.getLabelENFont()
        maxLabel.text = NSLocalizedString("Fast", comment: "")
        view.addSubview(maxLabel)
        
        /*
        saveButton.setupRoundBlack()
        saveButton.setTitle(NSLocalizedString("Save", comment: ""), for: .normal)
        saveButton.addTarget(self, action: #selector(pressedSaveButton), for: .touchUpInside)
        view.addSubview(saveButton)
        */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        setBackButtonAndUpdateTitle(customizedNavigationBar: customizedNavigationBar, title: NSLocalizedString("LRC Fee Ratio", comment: ""))
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
        let step: Float = 1
        let roundedStepValue = Int(round(sender.value / step))
        let perMillSymbol = NumberFormatter().perMillSymbol!
        typeLabel.text = "\(roundedStepValue)\(perMillSymbol)"
    }

    @objc func pressedSaveButton(_ sender: Any) {
        let step: Float = 1
        let newValue = Double(round(slider.value / step)) / 1000.0
        SettingDataManager.shared.setLrcFeeRatio(newValue)
        self.navigationController?.popViewController(animated: true)
    }

}
