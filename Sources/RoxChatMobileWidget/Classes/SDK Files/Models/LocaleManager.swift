//
//  LocaleManager.swift
//  RoxChatMobileWidget
//
//  Created by Anna Frolova on 08.04.2024.
//

import Foundation

public class LocaleManager {
    
    init() {}
    
    static func getLocale() -> String {
        
        var locale: String
        
        if #available(iOS 16, *) {
            locale = NSLocale.autoupdatingCurrent.language.languageCode?.identifier ?? "en"
        } else {
            locale = NSLocale.current.languageCode ?? "en"
        }
        
        if locale.starts(with: "uk") {
            locale = "ua"
        }
        
        return locale
    }
    
    public static func isRightOrientationLocale() -> Bool {
        let locale = self.getLocale()
        return locale == "ar" || locale == "he"
    }
    
}
