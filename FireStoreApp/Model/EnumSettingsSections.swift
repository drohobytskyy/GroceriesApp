//
//  EnumSettingsSections.swift
//  SideMenu
//
//  Created by @rtur drohobytskyy on 27/01/2020.
//  Copyright © 2020 @rtur drohobytskyy. All rights reserved.
//

enum SettingsSections: Int, CaseIterable, CustomStringConvertible {
    
    case Account
    case App
    
    var description: String {
        
        switch self {
        case .Account:
            return "Account"
        case .App:
            return "App"
        }
    }
}

enum AccountOptions: Int, CaseIterable, SectionType {
    
    case Profile
    case Alerts
    
    var description: String {
        
        switch self {
        case .Profile:
            return "Profile"
        case .Alerts:
            return "Alerts"
        }
    }
    
    var containsSwitch: Bool {
        return false
    }
}

enum AppOptions: Int, CaseIterable, SectionType {
    
    case Notifications
    case Authentication
    case Email
    
    var description: String {
        
        switch self {
        case .Notifications:
            return "Notifications"
        case .Authentication:
            return "Authentication"
        case .Email:
            return "Email"
        }
    }
    
    var containsSwitch: Bool {
        
        switch self {
        case .Notifications:
            return true
        case .Authentication:
            return false
        case .Email:
            return true
        }
    }
}
