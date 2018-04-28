//
//  CreateNewOfferTableViewController.swift
//  weCarry
//
//  Created by zixin cheng on 2018-02-21.
//  Copyright © 2018 zixin cheng. All rights reserved.
//

import UIKit
import Firebase

class CreateNewOfferTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource , UITextFieldDelegate{

    @IBOutlet weak var fromCountryTextField: UITextField!
    @IBOutlet weak var toCountryTextField: UITextField!
    @IBOutlet weak var fromCityTextField: UITextField!
    @IBOutlet weak var toCityTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var taxFreeBtn: UIButton!
    @IBOutlet weak var taobaoBtn: UIButton!
    @IBOutlet weak var buyBtn: UIButton!
    @IBOutlet weak var oneCaseBtn: UIButton!
    @IBOutlet weak var onebulkBtn: UIButton!
    @IBOutlet weak var leftWeightTextFiled: UITextField!
    
    var fromCountryPicker: UIPickerView! = UIPickerView()
    var toCountryPicker: UIPickerView! = UIPickerView()
    var fromCityPicker: UIPickerView! = UIPickerView()
    var toCityPicker: UIPickerView! = UIPickerView()
    var datePicker: UIDatePicker! = UIDatePicker()
    var db: Firestore!
    
    var allPickerInfo: NSDictionary = [:]
    var countryArray = Array<String>()
    var cityArray = Array<String>()
    var currentCityArray = Array<String>()
    
    enum PICKERS {
        case FROMCOUNTRY
        case TOCOUNTRY
        case FROMCITY
        case TOCITY
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // SET UP PICKERS VALUE
        self.fromCountryPicker.dataSource = self
        self.fromCountryPicker.delegate = self
        self.fromCountryPicker.tag = PICKERS.FROMCOUNTRY.hashValue;
        self.toCountryPicker.dataSource = self
        self.toCountryPicker.delegate = self
        self.toCountryPicker.tag = PICKERS.TOCOUNTRY.hashValue;
        self.fromCityPicker.dataSource = self
        self.fromCityPicker.delegate = self
        self.fromCityPicker.tag = PICKERS.FROMCITY.hashValue;
        self.toCityPicker.dataSource = self
        self.toCityPicker.delegate = self
        self.toCityPicker.tag = PICKERS.TOCITY.hashValue;
        
        self.fromCountryPicker.selectRow(1, inComponent: 0, animated: true)
        self.toCountryPicker.selectRow(0, inComponent: 0, animated: true)
        self.fromCountryPicker.reloadAllComponents()
        
        getAllPickerInfo();
    
        self.datePicker.locale = NSLocale.init(localeIdentifier: "zh-Hans") as Locale
        self.datePicker.datePickerMode = UIDatePickerMode.date
        
        self.datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        self.fromCountryPicker.showsSelectionIndicator = true
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        fromCountryTextField.inputView = self.fromCountryPicker
        fromCountryTextField.inputAccessoryView = toolBar
        self.toCountryTextField.inputView = self.toCountryPicker
        self.toCountryTextField.inputAccessoryView = toolBar
        self.dateTextField.inputView = self.datePicker;
        self.fromCityTextField.delegate = self;
        self.toCityTextField.delegate = self;
        self.leftWeightTextFiled.delegate = self;
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func donePicker(){
        
        self.fromCountryTextField.resignFirstResponder();
        self.toCountryTextField.resignFirstResponder();
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        dateFormatter.locale = NSLocale.init(localeIdentifier: "zh-Hans") as Locale
        self.dateTextField.text = dateFormatter.string(from: sender.date)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch (component)
        {
            case 0:
                return self.countryArray.count
            case 1:
                return self.currentCityArray.count
        default:
            return 0
        }
    }
    
    
    //MARK: Delegates
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (component == 0) {
            return self.countryArray[row];
        } else {
            return self.currentCityArray[row];
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (component == 0) {
            print("Country picker")
            let currentSelectedCounty = self.countryArray[row]
            self.currentCityArray = self.allPickerInfo.object(forKey: currentSelectedCounty) as! [String]
            pickerView.selectRow(0, inComponent: 1, animated: true)
            pickerView.reloadAllComponents()
            if (pickerView.tag == PICKERS.FROMCOUNTRY.hashValue) {
                self.fromCountryTextField.text = self.countryArray[row]
            } else if (pickerView.tag == PICKERS.TOCOUNTRY.hashValue) {
                self.toCountryTextField.text = self.countryArray[row]
            }
        } else {
            print("City picker")
            if (pickerView.tag == PICKERS.FROMCOUNTRY.hashValue) {
                self.fromCityTextField.text = self.currentCityArray[row]
            } else if (pickerView.tag == PICKERS.TOCOUNTRY.hashValue) {
                self.toCityTextField.text = self.currentCityArray[row]
            }
        }
    }
    
    // UITextField Delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("Begin")
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true;
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true;
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true;
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true;
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    @IBAction func doneBtnPressed(_ sender: Any) {
        
        if (self.fromCountryTextField.text == "" || self.toCountryTextField.text == "" || self.toCityTextField.text == "" || self.fromCityTextField.text == "" || self.dateTextField.text == "" || self.leftWeightTextFiled.text == "") {
            let alertController = UIAlertController(title: "Error", message: "Required field cannot be empty", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            }
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            var ref: DocumentReference? = nil
            ref = db.collection("offerListing").addDocument(data: [
                "avaliblePackage": ["可带散件": onebulkBtn.isSelected, "可带整箱": oneCaseBtn.isSelected],
                "avalibleService": ["代买物品": buyBtn.isSelected, "代免税店": taxFreeBtn.isSelected, "代收淘宝": taobaoBtn.isSelected],
                "leftWeight":  leftWeightTextFiled.text ?? "",
                "travelInfo": ["fromCountry": fromCountryTextField.text, "fromCity": fromCityTextField.text, "toCountry": toCountryTextField.text, "toCity": toCityTextField.text, "time": dateTextField.text],
                "userInfo": ["userId":  UserDefaults.standard.string(forKey: "userId"), "userName":  UserDefaults.standard.string(forKey: "nickName")]
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                    let userIdref = self.db.collection("users").document(UserDefaults.standard.string(forKey: "userId")!)
                    
                     userIdref.getDocument { (document, error) in
                        if let document = document, document.exists {
                            var offerIdArray = document.data()!["offerIds"] as! [String]
                            
                            offerIdArray.append(ref!.documentID);
                            
                            userIdref.updateData([
                                "offerIds": offerIdArray
                            ]) { err in
                                if let err = err {
                                    print("Error adding document: \(err)")
                                } else {
                                    print("Document updated");
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }
                            
                        } else {
                            print("Document does not exist")
                        }
                    }
                }
            }
            
        }
    }
    
    @IBAction func taxBtnPressed(_ sender: Any) {
        if self.taxFreeBtn.isSelected == true {
            self.taxFreeBtn.isSelected = false
        }else {
            self.taxFreeBtn.isSelected = true
        }
    }
    
    @IBAction func taobaoBtnPressed(_ sender: Any) {
        if self.taobaoBtn.isSelected == true {
            self.taobaoBtn.isSelected = false
        }else {
            self.taobaoBtn.isSelected = true
        }
    }
    
    @IBAction func buyBtnPressed(_ sender: Any) {
        if self.buyBtn.isSelected == true {
            self.buyBtn.isSelected = false
        }else {
            self.buyBtn.isSelected = true
        }
    }
    @IBAction func oneCaseBtnPressed(_ sender: Any) {
        if self.oneCaseBtn.isSelected == true {
            self.oneCaseBtn.isSelected = false
        }else {
            self.oneCaseBtn.isSelected = true
        }
    }
    @IBAction func oneBulkBtnPressed(_ sender: Any) {
        if self.onebulkBtn.isSelected == true {
            self.onebulkBtn.isSelected = false
        }else {
            self.onebulkBtn.isSelected = true
        }
    }
    
    func getAllPickerInfo(){
        
        //Load content of Info.plist into resourceFileDictionary dictionary
        if let path = Bundle.main.path(forResource: "CountryCity", ofType: "plist") {
            self.allPickerInfo = NSDictionary(contentsOfFile: path)!
        }
        if (self.allPickerInfo.count != 0) {
            self.countryArray = self.allPickerInfo.allKeys as! [String]
            self.currentCityArray = self.allPickerInfo.object(forKey: "中国") as! [String]
        }

    }

}
