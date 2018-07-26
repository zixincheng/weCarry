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
    var requestIds = [String]()
    
    var selectedObj = RequestListingObject(userInfo: ["":""], serviceType: "", packageType: "", travelInfo: ["":""], itemInfo: ["":""])
    
    var selectedRequestId : String = ""
    var deletedRequestId : String = ""
    var deleteIndexPath: NSIndexPath? = nil

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
                                                self.requestIds.append(id)
                                                
                                                self.tableView.reloadData()
                                        }
                                    }
                                }
                                
            
                            } else {
                                print("Document does not exist")
                            }
            
                        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        ObjectList.removeAll()
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedObj = self.ObjectList[indexPath.row]
        selectedRequestId = self.requestIds[indexPath.row]
        performSegue(withIdentifier: "editRequestSegue", sender: self)
    }
    
    func confirmDelete() {
        let alert = UIAlertController(title: "删除提供记录", message: "您确定要永久删除此条记录嘛?", preferredStyle: .actionSheet)
        
        let DeleteAction = UIAlertAction(title: "确定", style: .destructive, handler: handleDeletePlanet)
        let CancelAction = UIAlertAction(title: "取消", style: .cancel, handler: cancelDeletePlanet)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        alert.popoverPresentationController?.sourceView = self.view
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleDeletePlanet(alertAction: UIAlertAction!) -> Void {
        if let indexPath = self.deleteIndexPath {
            tableView.beginUpdates()
            db = Firestore.firestore()
            db.collection("requestListing").document(self.deletedRequestId).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    self.requestIds.remove(at: (self.deleteIndexPath?.row)!)
                    self.ObjectList.remove(at: (self.deleteIndexPath?.row)!)
                    // Note that indexPath is wrapped in an array:  [indexPath]
                    self.tableView.deleteRows(at: [indexPath as IndexPath], with: .automatic)
                    
                    self.deletedRequestId = ""
                    self.deleteIndexPath = nil
                    
                    self.tableView.endUpdates()
                    print("Document successfully removed!")
                }
            }
        }
    }
    
    func cancelDeletePlanet(alertAction: UIAlertAction!) {
        self.deletedRequestId = ""
        self.deleteIndexPath = nil
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.deletedRequestId =  self.requestIds[indexPath.row]
            self.deleteIndexPath = indexPath as NSIndexPath
            confirmDelete()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editRequestSegue" {
            
            let editRequestViewController = segue.destination as! EditRequestTableViewController
            editRequestViewController.selectedObj = self.selectedObj;
            editRequestViewController.selectedRequestId = self.selectedRequestId;
            
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
