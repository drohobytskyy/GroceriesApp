//
//  SignUpController.swift
//  FireStoreApp
//
//  Created by @rtur drohobytskyy on 29/01/2020.
//  Copyright © 2020 @rtur drohobytskyy. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpController: UIViewController {

    // MARK: - properties
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
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
        
        Utils.shared.customButton(signUpBtn, ButtonTypeEnum.signUp)
    }
    
    // MARK: - helpers
    private func validateFields() -> String? {
        
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)  == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
           
            return "All fields are required"
        }
        
        let userName = emailTextField.text!
        let password = passwordTextField.text!
        
        if(!Utils.shared.isPasswordValid(username: userName, password: password)) {
            return "Password is not secure"
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
    

    // MARK: - sign up
    @IBAction func signUpAction(_ sender: UIButton) {
        
        if let error = validateFields() {
            showErrorMessage(error)
        } else {
            
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                
                if let error = error {
                    self.showErrorMessage(error.localizedDescription)
                } else {
                    
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["id" : result!.user.uid, "email": email], completion: { (error) in
                        
                        if let error = error {
                            self.showErrorMessage(error.localizedDescription)
                        }
                    })
                    
                    self.transitionToHomeVC()
                }
            }
        }
    }
}
