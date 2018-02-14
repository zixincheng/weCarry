//
//  OfferingListViewControllerTableViewController.swift
//  
//
//  Created by zixin cheng on 2/6/18.
//

import UIKit
import Firebase

class OfferingListViewControllerTableViewController: UITableViewController {
    var db: Firestore!
    
    var ObjectList = [OfferListingObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        db.collection("offerListing").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in (snapshot!.documents) {
                    let obj = OfferListingObject(userId: document.data()["userId"] as! String, leftWeight: document.data()["leftWeight"] as! String, pickuplocation: document.data()["pickupLocation"] as! GeoPoint, avalibleService: document.data()["avalibleService"] as! [String : Bool], avaliblePackage: document.data()["avaliblePackage"] as! [String: Bool] , travelInfo: document.data()["travelInfo"] as! [String : String])
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
        return ObjectList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> OfferListingTableCell {
        tableView.register(UINib(nibName: "OfferListingTableCell", bundle: nil), forCellReuseIdentifier: "OfferlistingTableCell")
        let cell:OfferListingTableCell = tableView.dequeueReusableCell(withIdentifier: "OfferlistingTableCell", for: indexPath) as! OfferListingTableCell
        
        var numberOfAvalibleService = 0;
        var services = [String]();
        for (service, value) in self.ObjectList[indexPath.row].avalibleService {
            if  value {
                numberOfAvalibleService += 1;
                services.append(service);
            }
        }
        
        switch numberOfAvalibleService {
        case 0:
            break;
        case 1:
            cell.serviceLabel1.isHidden = false;
            cell.serviceLabel1.text = services[0];
        case 2:
            cell.serviceLabel1.isHidden = false;
            cell.serviceLabel1.text = services[0];
            cell.serviceLabel2.isHidden = false;
            cell.serviceLabel2.text = services[1];
        case 3:
            cell.serviceLabel1.isHidden = false;
            cell.serviceLabel1.text = services[0];
            cell.serviceLabel2.isHidden = false;
            cell.serviceLabel2.text = services[1];
            cell.serviceLabel3.isHidden = false;
            cell.serviceLabel3.text = services[2];
        default:
            break
        }
        
        var numberOfAvaliblePackage = 0;
        var packages = [String]();
        for (service, value) in self.ObjectList[indexPath.row].avaliblePackage {
            if  value {
                numberOfAvaliblePackage += 1;
                packages.append(service);
            }
        }
        
        switch numberOfAvaliblePackage {
        case 0:
            break;
        case 1:
            cell.packageLabel1.isHidden = false;
            cell.packageLabel1.text = packages[0];
        case 2:
            cell.packageLabel1.isHidden = false;
            cell.packageLabel1.text = packages[0];
            cell.packageLabel2.isHidden = false;
            cell.packageLabel2.text = packages[1];
        default:
            break
        }
        
        cell.fromLabel?.text = (self.ObjectList[indexPath.row].travelInfo["from"])
        cell.toLabel?.text = (self.ObjectList[indexPath.row].travelInfo["to"])
        cell.timeLabel?.text = (self.ObjectList[indexPath.row].travelInfo["time"])

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
