//
//  UserDefaultService.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/7/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Foundation

class UserDefaultService {
    
    enum Key: String {
        case token
    }
    
    static let shared = UserDefaultService()
    
    private let userDefaultsInstance = UserDefaults.standard
    
    @UserDefaultVariable(key: Key.token.rawValue, defaultValue: "")
    var token
    
    func removeAll() {
        for (key, _) in userDefaultsInstance.dictionaryRepresentation() {
            userDefaultsInstance.removeObject(forKey: key)
        }
    }
}
