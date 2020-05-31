//
//  UserDefaultPropertiesWrapper.swift
//  Cinematics
//
//  Created by Nghia Nguyen on 4/7/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Foundation

@propertyWrapper
struct UserDefaultObject<T: Codable> {
    private let key: String

    init(key: String) {
        self.key = key
    }

    var wrappedValue: T? {
        get {
            // Read value from UserDefaults
            guard let data = UserDefaults.standard.object(forKey: key) as? Data else {
                // Return defaultValue when no data in UserDefaults
                return nil
            }
            // Convert data to the desire data type
            let value = try? JSONDecoder().decode(T.self, from: data)
            return value
        }
        set {
            if newValue == nil {
                UserDefaults.standard.set(nil, forKey: key)
            } else {
                // Convert newValue to data
                let data = try? JSONEncoder().encode(newValue)
                // Set value to UserDefaults
                UserDefaults.standard.set(data, forKey: key)
            }
        }
    }
}

@propertyWrapper
struct UserDefaultVariable<T> {
    private let key: String
    private let defaultValue: T?

    init(key: String, defaultValue: T?) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T? {
        get {
            // Read value from UserDefaults
            return (UserDefaults.standard.object(forKey: key) as? T?) ?? defaultValue
        }
        set {
            // Set value to UserDefaults
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
