//
//  Localizator.swift
//  loopr-ios
//
//  Created by xiaoruby on 6/30/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

func LocalizedString(_ key: String, comment: String) -> String {
    return Localizator.sharedInstance.localizedStringForKey(key)
}

func SetLanguage(_ language: String) -> Bool {
    return Localizator.sharedInstance.setLanguage(language)
}

class Localizator {
    
    // MARK: - Private properties
    private let userDefaults = UserDefaults.standard
    private var availableLanguagesArray = ["DeviceLanguage", "en", "zh-Hans"]  // Need help to test language.
    private var dicoLocalization: NSDictionary?

    private let kSaveLanguageDefaultKey = "kSaveLanguageDefaultKey"
    
    // MARK: - Public properties
    var updatedLanguage: String?
    
    // MARK: - Singleton method
    class var sharedInstance: Localizator {
        struct Singleton {
            static let instance = Localizator()
        }
        return Singleton.instance
    }
    
    // MARK: - Init method
    init() {
        
    }
    
    // MARK: - Public custom getter
    
    func getArrayAvailableLanguages() -> [String] {
        return availableLanguagesArray
    }
    
    // MARK: - Private instance methods
    
    fileprivate func loadDictionaryForLanguage(_ newLanguage: String) -> Bool {
        let arrayExt = newLanguage.components(separatedBy: "_")
        for ext in arrayExt {
            if let path = Bundle(for: object_getClass(self)!).url(forResource: "Localizable", withExtension: "strings", subdirectory: nil, localization: ext)?.path {
                if FileManager.default.fileExists(atPath: path) {
                    updatedLanguage = newLanguage
                    dicoLocalization = NSDictionary(contentsOfFile: path)
                    return true
                }
            }
        }
        return false
    }
    
    fileprivate func localizedStringForKey(_ key: String) -> String {
        if let dico = dicoLocalization {
            if let localizedString = dico[key] as? String {
                return localizedString
            } else {
                return key
            }
        } else {
            return NSLocalizedString(key, comment: key)
        }
    }
    
    fileprivate func setLanguage(_ newLanguage: String) -> Bool {
        if (newLanguage == updatedLanguage) || !availableLanguagesArray.contains(newLanguage) {
            return false
        }

        if loadDictionaryForLanguage(newLanguage) {
            // Update the setting. It only works when the application is restarted.
            UserDefaults.standard.set([newLanguage], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
            
            // runtime
            NotificationCenter.default.post(name: .languageChanged, object: nil)
            return true
        }
        return false
    }

}
