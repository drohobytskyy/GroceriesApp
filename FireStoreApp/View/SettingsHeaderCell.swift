//
//  SettingsHeaderCell.swift
//  SideMenu
//
//  Created by @rtur drohobytskyy on 27/01/2020.
//  Copyright © 2020 @rtur drohobytskyy. All rights reserved.
//

import UIKit

class SettingsHeaderCell: UITableViewCell {
    
    var title: String? {
        didSet {
            guard let title = title else { return }
            textLabel?.text = title
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    private func configureUI() {
        
        backgroundColor = Utils.primaryColor
        
        textLabel?.textColor = .white
        textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        textLabel?.translatesAutoresizingMaskIntoConstraints = false
        textLabel?.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        textLabel?.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
