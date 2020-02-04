//
//  MenuController.swift
//  SideMenu
//
//  Created by @rtur drohobytskyy on 26/01/2020.
//  Copyright © 2020 @rtur drohobytskyy. All rights reserved.
//

import UIKit

private let cell_identifier = "MenuOptionCell"

class MenuController: UIViewController {
    
    // MARK: - Properties
    var tableView: UITableView!
    var delegate: HomeControllerDelegate?
    
    var menuOptions: [MenuOption] = []
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        menuOptions = Utils.shared.getMenuOptions()
    }
    
    // MARK: - Handlers
    func configureTableView() {
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MenuOptionCell.self, forCellReuseIdentifier: cell_identifier)
        
        tableView.backgroundColor = Utils.primaryColor
        //tableView.separatorStyle = .none
        tableView.separatorColor = Utils.separatorColor
        tableView.rowHeight = CGFloat(Utils.tableViewRowHeight)
        tableView.tableFooterView = UIView()
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}

extension MenuController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return menuOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cell_identifier, for: indexPath) as! MenuOptionCell
        
        let menuOption =  menuOptions[indexPath.row]
        
        cell.menuOption = menuOption
        
        return cell 
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let menuOption = menuOptions[indexPath.row]
        delegate?.handleMenuToggle(forMenuOption: menuOption)
    }
}
