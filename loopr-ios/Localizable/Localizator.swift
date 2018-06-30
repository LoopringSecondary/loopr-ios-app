//
//  Localizator.swift
//  loopr-ios
//
//  Created by xiaoruby on 6/30/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

let kNotificationLanguageChanged        = NSNotification.Name(rawValue:"kNotificationLanguageChanged")

func LocalizedString(_ key: String, comment: String) -> String {
    return Localizator.sharedInstance.localizedStringForKey(key)
}

func SetLanguage(_ language:String) -> Bool {
    return Localizator.sharedInstance.setLanguage(language)
}

class Localizator {
    
    // MARK: - Private properties
    
    private let userDefaults                    = UserDefaults.standard
    private var availableLanguagesArray         = ["DeviceLanguage", "en", "zh-Hans"]
    private var dicoLocalisation:NSDictionary!
    
    
    private let kSaveLanguageDefaultKey         = "kSaveLanguageDefaultKey"
    
    // MARK: - Public properties
    
    var currentLanguage                         = "DeviceLanguage"
    
    // MARK: - Public computed properties
    
    var saveInUserDefaults:Bool {
        get {
            return (userDefaults.object(forKey: kSaveLanguageDefaultKey) != nil)
        }
        set {
            if newValue {
                userDefaults.set(currentLanguage, forKey: kSaveLanguageDefaultKey)
            } else {
                userDefaults.removeObject(forKey: kSaveLanguageDefaultKey)
            }
            userDefaults.synchronize()
        }
    }
    
    
    // MARK: - Singleton method
    
    class var sharedInstance :Localizator {
        struct Singleton {
            static let instance = Localizator()
        }
        return Singleton.instance
    }
    
    // MARK: - Init method
    init() {
        if let languageSaved = userDefaults.object(forKey: kSaveLanguageDefaultKey) as? String {
            if languageSaved != "DeviceLanguage" {
                _ = self.loadDictionaryForLanguage(languageSaved)
            }
        }
    }
    
    // MARK: - Public custom getter
    
    func getArrayAvailableLanguages() -> [String] {
        return availableLanguagesArray
    }
    
    
    // MARK: - Private instance methods
    
    fileprivate func loadDictionaryForLanguage(_ newLanguage:String) -> Bool {
        
        let arrayExt = newLanguage.components(separatedBy: "_")
        
        for ext in arrayExt {
            if let path = Bundle(for: object_getClass(self)!).url(forResource: "Localizable", withExtension: "strings", subdirectory: nil, localization: ext)?.path {
                if FileManager.default.fileExists(atPath: path) {
                    currentLanguage = newLanguage
                    dicoLocalisation = NSDictionary(contentsOfFile: path)
                    return true
                }
            }
        }
        return false
    }
    
    fileprivate func localizedStringForKey(_ key:String) -> String {
        
        if let dico = dicoLocalisation {
            if let localizedString = dico[key] as? String {
                return localizedString
            }  else {
                return key
            }
        } else {
            return NSLocalizedString(key, comment: key)
        }
    }
    
    fileprivate func setLanguage(_ newLanguage:String) -> Bool {
        
        if (newLanguage == currentLanguage) || !availableLanguagesArray.contains(newLanguage) {
            return false
        }
        
        if newLanguage == "DeviceLanguage" {
            currentLanguage = newLanguage
            dicoLocalisation = nil
            userDefaults.removeObject(forKey: kSaveLanguageDefaultKey)
            NotificationCenter.default.post(name: kNotificationLanguageChanged, object: nil)
            return true
        } else if loadDictionaryForLanguage(newLanguage) {
            NotificationCenter.default.post(name: kNotificationLanguageChanged, object: nil)
            if saveInUserDefaults {
                userDefaults.set(currentLanguage, forKey: kSaveLanguageDefaultKey)
                userDefaults.synchronize()
            }
            return true
        }
        return false
    }
}

