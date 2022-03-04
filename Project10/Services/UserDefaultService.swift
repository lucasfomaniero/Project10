//
//  UserDefaultService.swift
//  Project10
//
//  Created by Lucas Maniero on 02/03/22.
//

import Foundation

class UserDefaultService {
    let defaults: UserDefaults = UserDefaults.standard
    init() {
    }
    
    
    func getObject<T: Any>(of type: T.Type, withKey key: String) -> T? {
        switch type {
        case is Int.Type:
            return defaults.integer(forKey:key) as? T
        case is Bool.Type:
            return defaults.bool(forKey:key) as? T
        case is Float.Type:
            return defaults.float(forKey:key) as? T
        default:
            return defaults.object(forKey:key) as? T
        }
    }
    
    func saveObject<T: Any>(_ object: T, withKey key: String) -> T?{
        defaults.set(object, forKey: key)
        return getObject(of: T.self, withKey: key)
    }
    
}
