//
//  ScanImageViewController.swift
//  AI Games
//
//  Created by Joshua Ki on 2/22/23.
//

import Foundation
import UIKit

class CameraViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    

    @IBOutlet weak var picButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        imageView.backgroundColor = .secondarySystemBackground
        
    }
    
    @IBAction func clicked(_ sender: Any) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        present(picker, animated: true, completion:nil)
    }
    
}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        imageView.image = image
    }
}
