//
//  MeTableViewController.swift
//  weCarry
//
//  Created by zixin cheng on 2018-03-02.
//  Copyright © 2018 zixin cheng. All rights reserved.
//

import UIKit
import Firebase

class MeTableViewController: UITableViewController, UITextFieldDelegate {
    var db: Firestore!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        
        //let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapOnNickNameLabel(_:)))
        //nickNameLabel.addGestureRecognizer(tap)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        db = Firestore.firestore()
        
        db.collection("users").document(UserDefaults.standard.string(forKey: "userId")!).getDocument { (document, error) in
            if let document = document, document.exists {
                //self.nickNameLabel.text = document.data()!["nickName"] as? String
            } else {
                print("Document does not exist")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // UITextField Delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("Begin")
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        print("did end")
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("should begin")
        return true;
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        print("clear")
        return true;
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("should end")
        return true;
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("Begin")
        return true;
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
    

    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
//    @objc func tapOnNickNameLabel(_ sender:UITapGestureRecognizer) {
//        let alertController = UIAlertController(title: "Alert", message: "Change the nick name", preferredStyle: UIAlertControllerStyle.alert)
//
//        alertController.addTextField { (textField : UITextField!) -> Void in
//            textField.placeholder = "Enter Nick Name"
//        }
//
//        let confirmAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
//            let nickNameTextField = alertController.textFields![0] as UITextField
//
//            let userIdref = self.db.collection("users").document(UserDefaults.standard.string(forKey: "userId")!)
//
//            userIdref.getDocument { (document, error) in
//                if let document = document, document.exists {
//
//                    userIdref.updateData([
//                        "nickName": nickNameTextField.text!
//                    ]) { err in
//                        if let err = err {
//                            print("Error adding document: \(err)")
//                        } else {
//                            print("Document updated");
//                            self.navigationController?.popViewController(animated: true)
//                        }
//                    }
//
//                } else {
//                    print("Document does not exist")
//                }
//
//            }
//        }
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action:UIAlertAction) in
//
//        }
//        alertController.addAction(confirmAction);
//        alertController.addAction(cancelAction);
//
//        self.present(alertController, animated: true, completion: nil)
//
//    }

    @IBAction func logoutBtnPressed(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
             UserDefaults.standard.removeObject(forKey: "userId")
            let initialViewController = storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = initialViewController
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
}
