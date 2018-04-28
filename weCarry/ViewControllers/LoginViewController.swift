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
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
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
                    let userId = (Auth.auth().currentUser?.uid)!
                    let docRef = self.db.collection("users").document(userId)
                    
                    docRef.getDocument { (document, error) in
                        if let document = document {
                            let userinfo = UserInfoObject.init(userId:userId , email: document.data()!["email"] as! String, nickName: document.data()!["nickName"] as! String, phoneNumber: document.data()!["phoneNumber"] as! String, offerIds: document.data()!["offerIds"] as! [String], requestIds: document.data()!["requestIds"] as! [String])
                                UserDefaults.standard.set(userId, forKey: "userId")
                                UserDefaults.standard.set(userinfo.nickName, forKey: "nickName")
                                UserDefaults.standard.set(userinfo.phoneNumber, forKey: "phoneNumber")
                        } else {
                            print("Document does not exist")
                        }
                    }
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
        
        let alertController = UIAlertController(title: "创建新账户", message: "请完成以下内容", preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "输入邮箱"
        }
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "输入密码"
        }
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "再次输入密码"
        }
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "输入昵称"
        }
        
        let confirmAction = UIAlertAction(title: "完成", style: .default) { (action:UIAlertAction) in
            let createaccountTextField = alertController.textFields![0] as UITextField
            let createpassworldTextField = alertController.textFields![1] as UITextField
            let confirmPasswordTextField = alertController.textFields![2] as UITextField
            let nickNameTextField = alertController.textFields![3] as UITextField
            
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
                        
                        //var ref: DocumentReference? = nil
                        self.db.collection("users").document((user?.uid)!).setData([
                            "email": createaccountTextField.text!,
                            "nickName": nickNameTextField.text!,
                            "offerIds":  [""],
                            "requestIds": [""],
                            "phoneNumber": "",
                            "userIcon": ""
                        ]) { err in
                            if let err = err {
                                print("Error adding document: \(err)")
                            } else {
                                print("Document added with ID: \(user?.uid)")
                            }
                        }
                        
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
        
        
        let cancelAction = UIAlertAction(title: "取消", style: .default) { (action:UIAlertAction) in
            
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

