//
//  AmountStack.swift
//  loopr-ios
//
//  Created by kenshin on 2018/5/25.
//  Copyright © 2018年 Loopring. All rights reserved.
//

import Foundation
import UIKit

protocol AmountStackViewDelegate: class {
    func setResultOfAmount(with percentage: Double)
}

@objc open class AmountStackView: UIStackView {
    
    weak var delegate: AmountStackViewDelegate?
    
    var infoLabel: UILabel!
    var plusButton: AmountButton!
    var minusButton: AmountButton!
    var timer: Timer!
    var progress: Double = 0
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        let width: Int = Int(frame.width)
        let height: Int = Int(frame.height * 0.6)
        let originY: Int = Int(frame.height * 0.2)
        
        minusButton = AmountButton(frame: CGRect(x: 0, y: originY, width: height, height: height))
        minusButton.closeWhenFinished = false
        minusButton.addTarget(self, action: #selector(start(_:)), for: .touchDown)
        minusButton.addTarget(self, action: #selector(stop(_:)), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(stop(_:)), for: .touchUpOutside)
        
        minusButton.buttonColor = UIColor.tokenestBackground
        minusButton.progressColor = UIColor.tokenestBackground
        minusButton.title = "-"
        minusButton.tag = 1
        minusButton.titleColor = UIColor.white
        minusButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 2, right: 0)

        plusButton = AmountButton(frame: CGRect(x: width-height, y: originY, width: height, height: height))
        plusButton.closeWhenFinished = false
        plusButton.addTarget(self, action: #selector(start(_:)), for: .touchDown)
        plusButton.addTarget(self, action: #selector(stop(_:)), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(stop(_:)), for: .touchUpOutside)
        
        plusButton.buttonColor = UIColor.tokenestBackground
        plusButton.progressColor = UIColor.tokenestBackground
        plusButton.title = "+"
        plusButton.tag = 0
        plusButton.titleColor = UIColor.white
        plusButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 2, right: 0)
        
        infoLabel = UILabel(frame: CGRect(x: height, y: 0, width: width-height*2, height: Int(frame.height)))
        infoLabel.textAlignment = .center
        infoLabel.text = "0%"
        
        self.axis = .horizontal
        self.distribution = .fillEqually
        self.addSubview(minusButton)
        self.addSubview(infoLabel)
        self.addSubview(plusButton)
    }
    
    required public init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func start(_ button: AmountButton) {
        if timer == nil || !timer.isValid {
            self.tag = button.tag
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        }
    }
    
    @objc func update() {
        if self.tag == 0 {
            progress += 0.01
            plusButton.setProgress(progress)
            if progress >= 1 {
                progress = 1
                timer.invalidate()
            }
        } else if self.tag == 1 {
            progress -= 0.01
            minusButton.setProgress(progress)
            if progress <= 0 {
                progress = 0
                timer.invalidate()
            }
        }
        let symbol: String = NumberFormatter().percentSymbol
        infoLabel.text = Double(progress * 100).withCommas(0) + symbol
        self.delegate?.setResultOfAmount(with: self.progress)
    }
    
    @objc func stop(_ button: AmountButton) {
        self.timer.invalidate()
        self.update()
        self.delegate?.setResultOfAmount(with: self.progress)
    }
    
    func clear() {
        if self.timer != nil && self.timer.isValid {
            self.timer.invalidate()
        }
        self.progress = 0
        self.plusButton.setProgress(0)
        self.minusButton.setProgress(0)
        self.infoLabel.text = "0%"
    }
}
