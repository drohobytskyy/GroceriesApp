//
//  SettingsController.swift
//  SideMenu
//
//  Created by @rtur drohobytskyy on 26/01/2020.
//  Copyright © 2020 @rtur drohobytskyy. All rights reserved.
//

import UIKit

private let cell_identifier = "settings_cell"
private let header_cell_identifier = "settings_header_cell"

class SettingsCotroller: UIViewController {
    
    // MARK: - Properties
    var tableView: UITableView!
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - helpers
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    private func configureTableView() {
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = CGFloat(Utils.tableViewRowHeight)
        
        tableView.register(SettingsCell.self, forCellReuseIdentifier: cell_identifier)
        tableView.register(SettingsHeaderCell.self, forCellReuseIdentifier: header_cell_identifier)
        view.addSubview(tableView)
        tableView.frame = view.frame
        tableView.tableFooterView = UIView()
    }
    
    private func configureUI() {
        
        configureTableView()
        
        view.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = Utils.primaryColor
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Settings"
        navigationController?.navigationBar.barStyle = Utils.navBarStyle
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "close")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
    }
}

extension SettingsCotroller: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerCell = tableView.dequeueReusableCell(withIdentifier: header_cell_identifier) as! SettingsHeaderCell
        
        headerCell.title = SettingsSections(rawValue: section)?.description
        
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let section = SettingsSections(rawValue: section) else { return 0 }
        
        switch section {
        case .Account:
            return AccountOptions.allCases.count
        case .App:
            return AppOptions.allCases.count

        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cell_identifier, for: indexPath) as! SettingsCell
        
        guard let section = SettingsSections(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .Account:
            let accountCell = AccountOptions(rawValue: indexPath.row)
            cell.sectionType = accountCell
        case .App: 
            let appCell = AppOptions(rawValue: indexPath.row)
             cell.sectionType = appCell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let section = SettingsSections(rawValue: indexPath.section) else { return }
        
        switch section {
        case .Account:
            print("action for account \(String(describing: AccountOptions(rawValue: indexPath.row)?.description))")
        case .App:
            print("action for account \(String(describing: AppOptions(rawValue: indexPath.row)))")
        }
    }
}
