//
//  RequestingDetailTableViewController.swift
//  weCarry
//
//  Created by zixin cheng on 2018-10-29.
//  Copyright © 2018 zixin cheng. All rights reserved.
//

import UIKit

class RequestingDetailTableViewController: UITableViewController {
    
    
    @IBOutlet weak var fromCountryTextField: UITextField!
    @IBOutlet weak var toCountryTextField: UITextField!
    @IBOutlet weak var fromCityTextField: UITextField!
    @IBOutlet weak var toCityTextField: UITextField!
    @IBOutlet weak var dateFromTextField: UITextField!
    @IBOutlet weak var dateToTextField: UITextField!
    @IBOutlet weak var dutyFreeBtn: UIButton!
    @IBOutlet weak var taobaoBtn: UIButton!
    @IBOutlet weak var buyBtn: UIButton!
    @IBOutlet weak var byCaseBtn: UIButton!
    @IBOutlet weak var byPieceBtn: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var weightTextFiled: UITextField!
    @IBOutlet weak var sizeTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var weChatTextField: UITextField!
    @IBOutlet weak var commentsTextView: UITextView!
    
    var selectedObj = RequestListingObject(userInfo: ["":""], serviceType: "", packageType: "", travelInfo: ["":""], itemInfo: ["":""], phoneNumber: "", weChat: "", comments: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fromCountryTextField.text = self.selectedObj.travelInfo["fromCountry"]
        self.fromCityTextField.text = self.selectedObj.travelInfo["fromCity"]
        self.toCountryTextField.text = self.selectedObj.travelInfo["toCountry"]
        self.toCityTextField.text = self.selectedObj.travelInfo["toCity"]
        self.dateFromTextField.text = self.selectedObj.travelInfo["earliestLimitTIme"]
        self.dateToTextField.text = self.selectedObj.travelInfo["latestLimitTime"]
        self.weightTextFiled.text = self.selectedObj.itemInfo["weight"]! + " KG"
        self.sizeTextField.text = self.selectedObj.itemInfo["size"]
        self.nameTextField.text = self.selectedObj.itemInfo["generalInfo"]
        self.weChatTextField.text = self.selectedObj.weChat
        self.phoneTextField.text = self.selectedObj.phoneNumber
        self.commentsTextView.text = self.selectedObj.comments
        
        let avalibleService = self.selectedObj.serviceType
        let avaliblePackage = self.selectedObj.packageType
        
        if (avaliblePackage == "散件") {
            self.byPieceBtn.isSelected = true;
        } else if(avaliblePackage == "整箱") {
            self.byCaseBtn.isSelected = true;
        }
        
        if (avalibleService == "代买物品") {
            self.buyBtn.isSelected = true
        } else if(avalibleService == "代免税店"){
            self.dutyFreeBtn.isSelected = true
        } else if (avalibleService == "代收淘宝") {
            self.taobaoBtn.isSelected = true;
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
    
}

