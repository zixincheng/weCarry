//
//  ViewController.swift
//  weCarry
//
//  Created by zixin cheng on 2/5/18.
//  Copyright © 2018 zixin cheng. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController{

    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginEmail(_ sender: Any) {
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityView.center = self.view.center
        activityView.startAnimating()
        
        self.view.addSubview(activityView)
        
        if let account = accountTextField.text, let pass = passwordTextField.text {
            Auth.auth().signIn(withEmail: account, password: pass) { (user, error) in
                activityView.stopAnimating()
                if let error = error {
                    let alertController = UIAlertController(title: "Login Failed", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    
                    let action1 = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                    }
                    
                    alertController.addAction(action1)
                    
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    print("login successfully");
                    self.performSegue(withIdentifier: "loginSuccessful", sender: nil);
                }
            }
        } else {
            activityView.stopAnimating()
            let alertController = UIAlertController(title: "Login Failed", message: "Account/Password cannot be empty", preferredStyle: UIAlertControllerStyle.alert)
            
            let action1 = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            }
            
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    @IBAction func createEmailAccount(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Alert", message: "This is an alert.", preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Email Address"
        }
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Password"
        }
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Confirm Password"
        }
        
        let confirmAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            let createaccountTextField = alertController.textFields![0] as UITextField
            let createpassworldTextField = alertController.textFields![1] as UITextField
            let confirmPasswordTextField = alertController.textFields![2] as UITextField
            
            if createpassworldTextField.text != confirmPasswordTextField.text || createpassworldTextField.text == "" || confirmPasswordTextField.text == "" {
                let alertController2 = UIAlertController(title: "Error", message: "Password do not match or cannot be empty", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                }
                
                alertController2.addAction(okAction)
                self.present(alertController2, animated: true, completion: nil)
            } else {
                let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                activityView.center = self.view.center
                activityView.startAnimating()
                
                self.view.addSubview(activityView)
                
                Auth.auth().createUser(withEmail: createaccountTextField.text!, password: createpassworldTextField.text!) { (user, error) in
                    activityView.stopAnimating()
                    if let error = error {
                        let alertController = UIAlertController(title: "Account Creation Failed", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                        
                        let action1 = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                            print("You've pressed default");
                        }
                        
                        alertController.addAction(action1)
                        self.present(alertController, animated: true, completion: nil)
                        print("login failed" ,error );

                    } else {
                        let alertController = UIAlertController(title: "Success", message: "Account create successfully", preferredStyle: UIAlertControllerStyle.alert)
                        
                        let action1 = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                            print("You've pressed default");
                        }
                        
                        alertController.addAction(action1)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action:UIAlertAction) in
            
        }
        alertController.addAction(confirmAction);
        alertController.addAction(cancelAction);
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

