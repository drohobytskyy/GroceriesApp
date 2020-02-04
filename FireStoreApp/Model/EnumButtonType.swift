//
//  EnumButtonType.swift
//  FireStoreApp
//
//  Created by @rtur drohobytskyy on 31/01/2020.
//  Copyright © 2020 @rtur drohobytskyy. All rights reserved.
//

enum ButtonTypeEnum: CustomStringConvertible {
    
    case signUp
    case login
    
    var description: String{
        switch self {
        case ButtonTypeEnum.signUp:
            return "signUp"
        case ButtonTypeEnum.login:
            return "login"
        }
    }
}
