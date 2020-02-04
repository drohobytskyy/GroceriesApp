//
//  ContainerController.swift
//  SideMenu
//
//  Created by @rtur drohobytskyy on 26/01/2020.
//  Copyright © 2020 @rtur drohobytskyy. All rights reserved.
//

import UIKit

class ContainerController: UIViewController {
    
    // MARK: - Properties
    var menuController: MenuController!
    var centeredController: UIViewController!
    var isExpanded: Bool = false
    
    var menuOptions: [MenuOption] = []
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHomeController()
        menuOptions = Utils.shared.getMenuOptions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navController = self.navigationController {
            navController.setNavigationBarHidden(true, animated: animated)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let navController = self.navigationController {
            navController.setNavigationBarHidden(false, animated: animated)
        }
    }
    
    // MARK: - Handlers
    func configureHomeController() {
        
        let homeController = HomeController()
        homeController.delegate = self
        centeredController = UINavigationController(rootViewController: homeController)
        
        view.addSubview(centeredController.view)
        addChild(centeredController)
        centeredController.didMove(toParent: self)
    }
    
    func configureMenuController() {
        
        if menuController == nil {
            
            menuController = MenuController()
            menuController.delegate = self
            view.insertSubview(menuController.view, at: 0)
            addChild(menuController)
            menuController.didMove(toParent: self)
        }
    }
    
    func showMenuContoller(expand: Bool, menuOption: MenuOption?) {
        
        if expand {
            
            UIView.animate(withDuration:  0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                
                self.centeredController.view.frame.origin.x = self.centeredController.view.frame.width - 80
                
            }, completion: nil)
        } else {
            
            UIView.animate(withDuration:  0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                
                self.centeredController.view.frame.origin.x = 0
                self.centeredController.view.backgroundColor = .white
                
            }) { (_) in
                
                guard let menuOption = menuOption else { return }
                self.didSelectAtMenuOption(menuOption: menuOption)
            }
        }
        
        animateStatusBar()
    }
    
    func didSelectAtMenuOption(menuOption: MenuOption) {
        
        guard let menuOption = EnumMenuOptions(rawValue: menuOption.name) else { return }
        
        switch menuOption {
        case .Home:
            print("Home")
        case .Settings:
            print("Settings")
            let controller = SettingsCotroller()
            present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        case .Logout:
            print("Logout")
            API.shared.logout(transitionToInitialController: transitionToInitialController)
            transitionToInitialController()
        }
    }
    
    private func transitionToInitialController() {
        
        if let navController = self.navigationController {
            navController.popViewController(animated: false)
        }
    }
    
    func animateStatusBar() {
        
        UIView.animate(withDuration:  0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            
            self.setNeedsStatusBarAppearanceUpdate()
            
        }, completion: nil)
    }
}

extension ContainerController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool {
         return isExpanded
    }
}

extension ContainerController: HomeControllerDelegate {
    
    func handleMenuToggle(forMenuOption menuOption: MenuOption?) {
        if !isExpanded {
            configureMenuController()
        }
        
        isExpanded = !isExpanded
        showMenuContoller(expand: isExpanded, menuOption: menuOption)
    }
}
