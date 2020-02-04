//
//  LoginController.swift
//  FireStoreApp
//
//  Created by @rtur drohobytskyy on 29/01/2020.
//  Copyright © 2020 @rtur drohobytskyy. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginController: UIViewController {
    
    // MARK: - properties
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
    }
    
    // MARK: - layout config
    private func setupLayout() {
        
        errorLabel.alpha = 0
        
        Utils.shared.customTextField(emailTextField)
        Utils.shared.customTextField(passwordTextField)
        
        Utils.shared.customButton(loginBtn, ButtonTypeEnum.login)
    }
    
    // MARK: - helpers
    private func validateFields() -> String? {
        
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)  == "" ||
           passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "All fields are required"
        }
        
        return nil
    }
    
    private func showErrorMessage(_ errorMessage: String) {
        errorLabel.text! = errorMessage
        errorLabel.alpha = 1
    }
    
    private func transitionToHomeVC() {
        
        let containerVC = ContainerController()
        
        if let navController = self.navigationController {
            navController.pushViewController(containerVC, animated: true)
        }
    }

    // MARK: - login
    @IBAction func loginAction(_ sender: UIButton) {
        
        if let error = validateFields(){
            showErrorMessage(error)
        } else {
            
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().signIn(withEmail: email, password: password) { (result , error) in
                if let error = error {
                    self.showErrorMessage(error.localizedDescription)
                } else {
                    self.transitionToHomeVC()
                }
            }
        }
    }
    
}
