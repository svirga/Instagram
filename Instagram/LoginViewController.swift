//
//  LoginViewController.swift
//  Instagram
//
//  Created by Simona Virga on 2/5/18.
//  Copyright © 2018 Simona Virga. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
  
  @IBOutlet weak var usernameField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  
  let userExistsAlert = UIAlertController(title: "User Exists", message: "The username you have chosen already exists", preferredStyle: .alert)
  let invalidAlert = UIAlertController(title: "Invalid ", message: "The username or password was invalid. Please try again.", preferredStyle: .alert)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupAlertControllers()
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func onSignIn(_ sender: Any) {
    
    if !validateFields() {
      self.present(self.invalidAlert, animated: true) {
        // optional code for what happens after the alert controller has finished presenting
      }
      return
    }
    
    PFUser.logInWithUsername(inBackground: usernameField.text!, password: passwordField.text!) { (user: PFUser?, error: Error?) in
      if user != nil {
        print("Yay, you logged in!")
        self.performSegue(withIdentifier: "loginSegue", sender: nil)
      } else {
        print("Error: \(String(describing: error?.localizedDescription))")
        
        self.present(self.invalidAlert, animated: true) {
          // optional code for what happens after the alert controller has finished presenting
        }
        
      }
    }
  }
  
  @IBAction func onSignUp(_ sender: Any) {
    let newUser = PFUser()
    
    if !validateFields() {
      self.present(self.invalidAlert, animated: true) {
        // optional code for what happens after the alert controller has finished presenting
      }
      return
    }
    
    newUser.username = usernameField.text
    newUser.password = passwordField.text
    
    newUser.signUpInBackground { (success: Bool, error: Error?) in
      if success {
        print("Yay, registered a user!")
        self.performSegue(withIdentifier: "loginSegue", sender: nil)
      } else {
        print("Error: \(String(describing: error?.localizedDescription))")
        if String(describing: error?.localizedDescription).contains("Account already exists for this username.") {
          print("This user already has an account!!")
          
          self.present(self.userExistsAlert, animated: true) {
            // optional code for what happens after the alert controller has finished presenting
          }
        }
      }
    }
  }
  
  func setupAlertControllers() {
    // Set up alert for pre-existing username
    let OKAction = UIAlertAction(title: "OK", style: .destructive) { (action) in
      
    }
    self.userExistsAlert.addAction(OKAction)
    self.invalidAlert.addAction(OKAction)

  }
  
  func validateFields() -> Bool {
    return usernameField.hasText && passwordField.hasText
  }
  

  
}
