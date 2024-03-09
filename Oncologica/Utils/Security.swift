//
//  Security.swift
//  Oncologica
//
//  Created by Daniil Mashkov on 05.01.2024.
//

import Foundation
import SwiftUI


struct Keychain {
    
    func saveChain(email: String, password: String) {
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: email.data(using: .utf8)!,
            kSecValueData as String: password.data(using: .utf8)!]
        
            let status = SecItemAdd(attributes as CFDictionary, nil)

//        if SecItemAdd(attributes as CFDictionary, nil) == noErr {
//            print("User saved successfully in the keychain")
//        } else {
//            print("Something went wrong trying to save the user in the keychain")
//        }
    }
    
    func retrieveUserPassword(email: String) -> String {
        // Set query
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: email.data(using: .utf8)!,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecReturnData as String: true,]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        if status == 0 {
            let existingItem = item as! [String: Any]
            let password = String(data: (existingItem[kSecValueData as String] as? Data)!, encoding: .utf8)
            return password!
        } else {
            return "not found"
        }
    
    }
    
    func updateUser(email: String, password: String) {
        // Set query
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: email,
        ]
        // Set attributes for the new password
        let attributes: [String: Any] = [kSecValueData as String: password]
        // Find user and update
        if SecItemUpdate(query as CFDictionary, attributes as CFDictionary) == noErr {
            print("Password has changed")
        } else {
            print("Something went wrong trying to update the password")
        }
    }
    
    func deleteUser(email: String) {
        // Set query
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: email,
        ]
        // Find user and delete
        if SecItemDelete(query as CFDictionary) == noErr {
            print("User removed successfully from the keychain")
        } else {
            print("Something went wrong trying to remove the user from the keychain")
        }
    }
}
