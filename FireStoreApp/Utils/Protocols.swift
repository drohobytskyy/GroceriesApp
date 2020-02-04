 //
//  Protocols.swift
//  SideMenu
//
//  Created by @rtur drohobytskyy on 26/01/2020.
//  Copyright © 2020 @rtur drohobytskyy. All rights reserved.
//

 protocol HomeControllerDelegate {
    func handleMenuToggle(forMenuOption menuOption: MenuOption?)
 }
 
 protocol SectionType: CustomStringConvertible {
    var containsSwitch: Bool { get }
 }
