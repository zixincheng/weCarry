//
//  RequestingListTableViewController.swift
//  weCarry
//
//  Created by zixin cheng on 2018-02-14.
//  Copyright © 2018 zixin cheng. All rights reserved.
//

import UIKit
import Firebase

class RequestingListTableViewController: UITableViewController {
    var db: Firestore!
    
    var ObjectList = [RequestListingObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        db.collection("requestListing").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in (snapshot!.documents) {
                    let obj = RequestListingObject(userInfo: document.data()["userInfo"] as! [String: String], pickuplocation: document.data()["pickupLocation"] as! GeoPoint, serviceType: document.data()["serviceType"] as! String, packageType: document.data()["packageType"] as! String , travelInfo: document.data()["travelInfo"] as! [String : String], itemInfo: document.data()["itemInfo"] as! [String : String])
                    self.ObjectList.append(obj)

                    self.tableView.reloadData()
                }
            }
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        cell.fromLabel.text = (self.ObjectList[indexPath.row].travelInfo["from"])
        cell.toLabel.text = (self.ObjectList[indexPath.row].travelInfo["to"])
        cell.timeUpRangeLabel.text = (self.ObjectList[indexPath.row].travelInfo["upperLimitTime"])
        cell.timeLowRangeLabel.text = (self.ObjectList[indexPath.row].travelInfo["lowerLimitTime"])
        cell.serviceTypeLabel.text = self.ObjectList[indexPath.row].serviceType
        cell.packageTypeLabel.text = self.ObjectList[indexPath.row].packageType
        cell.weightLabel.text = (self.ObjectList[indexPath.row].itemInfo["weight"])

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return 175
    }
    
 

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
