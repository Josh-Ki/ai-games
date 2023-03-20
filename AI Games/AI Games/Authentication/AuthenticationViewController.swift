//
//  AuthenticationViewController.swift
//  AI Games
//
//  Created by Joshua Ki on 2/26/23.
//

import UIKit


//class AuthenticationViewController: UIViewController, UINavigationBarDelegate {
//
//    @IBOutlet weak var emailTextField: UITextField!
//    @IBOutlet weak var passwordTextField: UITextField!
//    @IBOutlet weak var signUpButton: UIButton!
//    @IBOutlet weak var loginButton: UIButton!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//    }
//
//    @IBAction func signUpTapped(_ sender: Any) {
//        guard let email = emailTextField.text, !email.isEmpty,
//                let password = passwordTextField.text, !password.isEmpty,
//                let confirmPassword = passwordTextField.text, !confirmPassword.isEmpty,
//                password == confirmPassword else {
//                // Display error message to user
//                return
//            }
//            
//            // Create user account in Firebase Authentication
//            Auth.auth().createUser(withEmail: email, password: password) { [weak self] (result, error) in
//                guard let strongSelf = self else {
//                    return
//                }
//                
//                if error == nil {
//                    // User account created successfully
//                    // Navigate to next screen or perform any other action
//                    print("USer created")
//                    strongSelf.performSegue(withIdentifier: "showTabBarController", sender: strongSelf)
//                } else {
//                    print("DIDNT CREATE")
//                    // Error creating user account
//                    // Display error message to user
//                }
//            }
//    }
//    
//    @IBAction func loginTapped(_ sender: Any) {
//        guard let email = emailTextField.text, let password = passwordTextField.text else {
//            return
//        }
//        
//        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
//            guard let strongSelf = self else {
//                return
//            }
//            
//            if error == nil {
//                // User logged in successfully
//                // Navigate to next screen or perform any other action
//                strongSelf.performSegue(withIdentifier: "showTabBarController", sender: strongSelf)
//            } else {
//                // Error logging in user
//                // Display error message to user
//            }
//        }
//
//    }
//    
//    
//
//}
//
