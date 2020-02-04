//
//  SpinnerViewController.swift
//  FireStoreApp
//
//  Created by @rtur drohobytskyy on 04/02/2020.
//  Copyright © 2020 @rtur drohobytskyy. All rights reserved.
//

import UIKit

class SpinnerViewController: UIViewController {
    
    var spinner = UIActivityIndicatorView(style: .whiteLarge)
    
    override func loadView() {
        
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)
        
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
}
