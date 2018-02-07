//
//  PostViewController.swift
//  Instagram
//
//  Created by Simona Virga on 2/5/18.
//  Copyright © 2018 Simona Virga. All rights reserved.
//

import UIKit
import Parse

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  
  @IBOutlet weak var postImageView: UIImageView!
  @IBOutlet weak var postTextField: UITextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
        
  }
  
  override func viewDidAppear(_ animated: Bool) {
    if postImageView.image == nil {
      createImagePicker()
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func createImagePicker() {
    let isCameraAvailable =
      UIImagePickerController.isSourceTypeAvailable(.camera)
    
    let sourceType = isCameraAvailable ?
      UIImagePickerControllerSourceType.camera :
      UIImagePickerControllerSourceType.photoLibrary
    
    let vc = UIImagePickerController()
    vc.delegate = self
    vc.sourceType = sourceType
    
    self.present(vc, animated: true, completion: nil)
  }
  
  @IBAction func sharePressed(_ sender: Any) {
    // Share the photo
    Post.postUserImage(image: postImageView.image, withCaption: postTextField.text) { (success: Bool, error: Error?) in
      if success {
        self.postImageView.image = nil
        self.tabBarController?.selectedIndex = 0
        print("success")
        self.performSegue(withIdentifier: "postPhotoSegue", sender: nil)
      } else {
        print("error: \(String(describing: error))")
        print("failed")
      }
    }
  }
  
  
  @IBAction func cancelPressed(_ sender: Any) {
    // Go back to the feed tab
    postImageView.image = nil
    self.tabBarController?.selectedIndex = 0
  }
  
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    
    let image: UIImage!
    if (info[UIImagePickerControllerEditedImage] as? UIImage) != nil {
      image = info[UIImagePickerControllerEditedImage] as! UIImage
    } else {
      image = info[UIImagePickerControllerOriginalImage] as! UIImage
    }
    
    postImageView.image = image
    
    dismiss(animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    self.tabBarController?.selectedIndex = 0
    dismiss(animated: true, completion: nil)
  }
  
  
}
