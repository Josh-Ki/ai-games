//
//  ProfileViewController.swift
//  AI Games
//
//  Created by Joshua Ki on 4/17/23.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import FirebaseDatabase

class ImageCache {
    private let cache = NSCache<NSString, UIImage>()
    private var dictionary = [String: NSString]()
    
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
        dictionary[key] = key as NSString
    }
    
    func image(forKey key: String) -> UIImage? {
        if let image = cache.object(forKey: key as NSString) {
            return image
        } else if let path = dictionary[key], let image = UIImage(contentsOfFile: path as String) {
            cache.setObject(image, forKey: key as NSString)
            return image
        }
        return nil
    }
}


class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UITextFieldDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var dataView: UIView!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet weak var deleteAccountButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    var profile : Profile?
    private let imageCache = ImageCache()
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        dataView.backgroundColor = UIColor(red: 1.0, green: 0.9, blue: 0.8, alpha: 1.0)
        let games = ["connect4", "sudoku", "gomoku", "tictactoe"]
        let difficulties = ["Easy", "Med", "Hard"]

        var highestTotals: [String: [String: Int]] = [:]
        let database = Firestore.firestore()

        // Create a dispatch group to keep track of when all queries have completed
        let group = DispatchGroup()
        
        // Create the indicator
        let indicator = UIActivityIndicatorView(style: .gray)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        self.dataView.addSubview(indicator)

        // Center the indicator in the dataView
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: self.dataView.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: self.dataView.centerYAnchor)
        ])

        // Start animating the indicator
        indicator.startAnimating()

        for game in games {
            highestTotals[game] = [:]
            for difficulty in difficulties {
                let collectionRef = database.collection("/users/\(userID)/\(game)/difficulty/\(difficulty)")

                // Enter the dispatch group before performing the query
                group.enter()

                // Check if the current game is "sudoku" and use the field "wins" instead of "total"
                let field = game == "sudoku" ? "wins" : "total"
                collectionRef.order(by: field, descending: true).limit(to: 1).getDocuments { snapshot, error in
                    if let error = error {
                        print("Error fetching highest total for \(game) \(difficulty): \(error)")
                    } else if let document = snapshot?.documents.first {
                        let total = document.data()[field] as? Int
                        highestTotals[game]?[difficulty] = total
                    }

                    // Leave the dispatch group after the query has completed
                    group.leave()
                }
            }
        }

        // Wait for all queries to complete before using the highestTotals dictionary
        group.notify(queue: .main) {
            print(highestTotals)
        }
        
        // Wait for all queries to complete before using the highestTotals dictionary
        group.notify(queue: .main) {
            indicator.stopAnimating()
            let games = ["connect4", "sudoku", "gomoku", "tictactoe"]
            let difficulties = ["Easy", "Med", "Hard"]
            let textColor = UIColor.systemCyan
            let font = UIFont(name: "Chalkduster", size: 17)!
            var yOffset: CGFloat = 0
            let labelHeight: CGFloat = self.dataView.frame.height / CGFloat(games.count + 1) // Calculate the height of each label based on the number of games and the height of the view
            let titleLabel = UILabel(frame: CGRect(x: 0, y: yOffset, width: self.dataView.frame.width, height: labelHeight))
            titleLabel.text = "Total Games"
            titleLabel.textColor = textColor
            titleLabel.textAlignment = .center
            titleLabel.font = font
            self.dataView.addSubview(titleLabel)
            yOffset += labelHeight
            for game in games {
                var total = 0
                for difficulty in difficulties {
                    total += highestTotals[game]?[difficulty] ?? 0
                    
                }
                let label = UILabel(frame: CGRect(x: 0, y: yOffset, width: self.dataView.frame.width, height: labelHeight))
                label.text = "\(game): \(total)"
                label.textColor = textColor
                label.textAlignment = .center
                label.font = font
                self.dataView.addSubview(label)
                yOffset += labelHeight
                
            }
            
        }

        print(highestTotals)
        if let imageData = UserDefaults.standard.data(forKey: "profileImage") {
            let image = UIImage(data: imageData)
            imageView.image = image
        } else {
            // If the image is not cached, download it from Firebase
            let storageRef = Storage.storage().reference().child("images/profile/\(userID).jpg")

            storageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
                if let error = error {
                    print("Error downloading profile image: \(error.localizedDescription)")
                } else if let imageData = data {
                    let image = UIImage(data: imageData)
                    // Cache the image
                    UserDefaults.standard.set(imageData, forKey: "profileImage")
                    // Set the image view's image
                    self.imageView.image = image
                }
            }
        }

        nameTextField.delegate = self
        nameTextField.borderStyle = .line
        nameTextField.layer.borderWidth = 1.0
        let placeholderText = "Enter your name here!"
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.gray]
        nameTextField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        nameTextField.layer.borderColor = UIColor.black.cgColor
        nameTextField.textColor = UIColor.black
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
        let tapGestureProfile = UITapGestureRecognizer(target: self, action: #selector(changeProfilePicture))
        imageView.addGestureRecognizer(tapGestureProfile)
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
               tapGesture.cancelsTouchesInView = true
               view.addGestureRecognizer(tapGesture)
        
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
           if let text = textField.text {
               // Save the text to a property of your view controller
               print(text)
               nameTextField.borderStyle = .none
               nameTextField.layer.borderWidth = 0.0
           }
       }
       
       // Dismiss keyboard when user taps outside of the text field or image view
       @objc func dismissKeyboard() {
           view.endEditing(true)
       }

       // Dismiss keyboard when user presses return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
            guard let imageData = image.jpegData(compressionQuality: 0.75) else {
                print("Failed to convert image to Data.")
                return
            }
            let storageRef = Storage.storage().reference().child("images/profile/\(userID).jpg")
            storageRef.putData(imageData, metadata: nil) { metadata, error in
                if let error = error {
                    print("Error uploading profile image: \(error.localizedDescription)")
                } else {
                    print("Profile image uploaded successfully!")
                }
            }

            



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
