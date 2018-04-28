//
//  PersonalRequestTableViewController.swift
//  weCarry
//
//  Created by zixin cheng on 2018-04-17.
//  Copyright © 2018 zixin cheng. All rights reserved.
//

import UIKit
import Firebase

class PersonalRequestTableViewController: UITableViewController {
    
    var db: Firestore!
    
    var ObjectList = [RequestListingObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        db = Firestore.firestore()
        
        let userIdref = self.db.collection("users").document(UserDefaults.standard.string(forKey: "userId")!)
        var requestIds = [String]()
        
        userIdref.getDocument { (document, error) in
                            if let document = document, document.exists {
            
                                requestIds = document.data()!["requestIds"] as! [String]
                                
                                for id in requestIds {
                                    let requestIdref = self.db.collection("requestListing").document(id)
                                    requestIdref.getDocument { (request, error) in
                                        if let request = request, request.exists {
                                            let obj = RequestListingObject(userInfo: request.data()!["userInfo"] as! [String: String], serviceType: request.data()!["serviceType"] as! String, packageType: request.data()!["packageType"] as! String , travelInfo: request.data()!["travelInfo"] as! [String : String], itemInfo: request.data()!["itemInfo"] as! [String : String])
                                                self.ObjectList.append(obj)
                                                
                                                self.tableView.reloadData()
                                        }
                                    }
                                }
                                
            
                            } else {
                                print("Document does not exist")
                            }
            
                        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ObjectList.count;
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> RequestListingTableViewCell {
        tableView.register(UINib(nibName: "RequestListingTableViewCell", bundle: nil), forCellReuseIdentifier: "RequestListingTableViewCell")
        let cell:RequestListingTableViewCell = tableView.dequeueReusableCell(withIdentifier: "RequestListingTableViewCell", for: indexPath) as! RequestListingTableViewCell
        
        cell.userNameLabel.text = (self.ObjectList[indexPath.row].userInfo["userName"])
        cell.fromLabel.text = (self.ObjectList[indexPath.row].travelInfo["fromCountry"])
        cell.toLabel.text = (self.ObjectList[indexPath.row].travelInfo["toCountry"])
        cell.fromCityLabel?.text = (self.ObjectList[indexPath.row].travelInfo["fromCity"])
        cell.toCityLabel?.text = (self.ObjectList[indexPath.row].travelInfo["toCity"])
        cell.timeUpRangeLabel.text = (self.ObjectList[indexPath.row].travelInfo["latestLimitTime"])
        cell.timeLowRangeLabel.text = (self.ObjectList[indexPath.row].travelInfo["earliestLimitTIme"])
        cell.serviceTypeLabel.text = self.ObjectList[indexPath.row].serviceType
        cell.packageTypeLabel.text = self.ObjectList[indexPath.row].packageType
        cell.weightLabel.text = (self.ObjectList[indexPath.row].itemInfo["weight"])! + " KG"
        
        // Configure the cell...
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return 175
    }

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

}
