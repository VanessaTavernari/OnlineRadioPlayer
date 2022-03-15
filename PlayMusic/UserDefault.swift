//
//  UserDefault.swift
//  PlayMusic
//
//  Created by Vanessa Tavares Tavernari on 01/03/2022.
//

import Foundation

extension UserDefaults {
    func setShouldAutoPlay(value: Bool?) {
        if value != nil {
            UserDefaults.standard.set(value, forKey: "Switch_State")
        } else {
            UserDefaults.standard.removeObject(forKey: "Switch_State")
        }
        UserDefaults.standard.synchronize()
    }
    
    func shouldAutoPlay() -> Bool? {
        return UserDefaults.standard.value(forKey: "Switch_State") as? Bool
        
    }
}
