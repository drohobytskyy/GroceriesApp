//
//  SettingsCell.swift
//  SideMenu
//
//  Created by @rtur drohobytskyy on 27/01/2020.
//  Copyright © 2020 @rtur drohobytskyy. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {

    // MARK: - properties
    var sectionType: SectionType? {
        didSet {
            
            guard let sectionType = sectionType else { return }
            textLabel?.text = sectionType.description
            switchControl.isHidden = !sectionType.containsSwitch
            
            selectionStyle = .none
        }
    }
    
    lazy var switchControl: UISwitch = {
        
        let switchControl = UISwitch()
        switchControl.isOn = true
        switchControl.onTintColor = Utils.primaryColor
        switchControl.addTarget(self, action: #selector(handleSwitchAction), for: .valueChanged)
        return switchControl
    }()
    
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(switchControl)
        
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        switchControl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        switchControl.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Handlers
    @objc func handleSwitchAction(sender: UISwitch) {
        
        if sender.isOn {
            print("on")
        } else {
            print("off")
        }
    }

}
