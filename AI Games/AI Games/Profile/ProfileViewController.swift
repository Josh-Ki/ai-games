//
//  ProfileViewController.swift
//  AI Games
//
//  Created by Joshua Ki on 4/17/23.
//

import Foundation
import UIKit
import FirebaseAuth
class ProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 1.0, green: 0.9, blue: 0.8, alpha: 1.0)
        
        // Set the image view's content mode to scaleAspectFill
        imageView.contentMode = .scaleAspectFill
        
        // Set the image view's corner radius to half of its width
        imageView.layer.cornerRadius = imageView.frame.width / 2
        
        // Make sure the image is clipped to the rounded shape
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2.0
        imageView.layer.borderColor = UIColor.black.cgColor
        
        // Add a tap gesture recognizer to the image view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeProfilePicture))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        
        
    }
    @objc func changeProfilePicture() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        let alert = UIAlertController(title: "Change Profile Picture", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // Delegate method called when the user selects an image
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageView.image = image
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // Delegate method called when the user cancels the image picker
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func logoutPressed(_ sender: Any) {
        // Handle logout here
        print("Clicked")
        do {
            try Auth.auth().signOut()
            // User logged out successfully
            // Navigate to previous screen or perform any other action
            
            if let navigationController = self.navigationController {
                navigationController.popViewController(animated: true)
            }
        } catch {
            // Error logging out user
            // Display error message to user
        }
    }
    
    @IBAction func deleteAccountButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Delete Account", message: "Are you sure you want to delete your account?", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Enter your password"
            textField.isSecureTextEntry = true
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            guard let password = alert.textFields?.first?.text else { return }
            
            let user = Auth.auth().currentUser
            
            let credential = EmailAuthProvider.credential(withEmail: user?.email ?? "", password: password)
            
            user?.reauthenticate(with: credential) { _, error in
                if let error = error {
                    print("Error reauthenticating user:", error.localizedDescription)
                    return
                }
                
                user?.delete { error in
                    if let error = error {
                        print("Error deleting user account:", error.localizedDescription)
                        return
                    }
                    
                    print("User account deleted successfully")
                    
                    // Navigate to previous screen or perform any other action
                    if let navigationController = self.navigationController {
                        navigationController.popViewController(animated: true)
                    }
                }
            }
        }))
        
        present(alert, animated: true)
        
    }
}
