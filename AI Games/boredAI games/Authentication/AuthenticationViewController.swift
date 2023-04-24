//
//  AuthenticationViewController.swift
//  AI Games
//
//  Created by Joshua Ki on 2/26/23.
//

import UIKit
import FirebaseAuth

class AuthenticationViewController: UIViewController, UINavigationBarDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //Looks for single or multiple taps.
         let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
        view.backgroundColor = UIColor(red: 1.0, green: 0.9, blue: 0.8, alpha: 1.0)

        
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    

    @IBAction func signUpTapped(_ sender: Any) {

        guard let email = emailTextField.text, !email.isEmpty,
                let password = passwordTextField.text, !password.isEmpty,
                let confirmPassword = passwordTextField.text, !confirmPassword.isEmpty,
                password == confirmPassword else {
                // Display error message to user
                return
            }
            
            // Create user account in Firebase Authentication
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] (result, error) in
                guard self != nil else {
                    return
                }
                
                if error == nil {
                    // User account created successfully
                    // Navigate to next screen or perform any other action
                    print("USer created")
                    userID = Auth.auth().currentUser!.uid
                    self?.navigationController?.popViewController(animated: true)
                } else {
                    print("DIDNT CREATE")
                    // Error creating user account
                    // Display error message to user
                }
            }
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
            guard self != nil else {
                return
            }
            
            if error == nil {
                userID = Auth.auth().currentUser!.uid
                // User logged in successfully
                // Navigate to next screen or perform any other action
                self?.navigationController?.popViewController(animated: true)
            } else {
                // Error logging in user
                // Display error message to user
            }
        }

    }
    
    

}

