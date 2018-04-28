//
//  CreateNewRequestTableViewController.swift
//  weCarry
//
//  Created by zixin cheng on 2018-02-21.
//  Copyright © 2018 zixin cheng. All rights reserved.
//

import UIKit
import Firebase

class CreateNewRequestTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource , UITextFieldDelegate {
    
    @IBOutlet weak var itemNameTextfield: UITextField!
    @IBOutlet weak var itemWeightTextField: UITextField!
    @IBOutlet weak var itemSizeTextField: UITextField!
    
    @IBOutlet weak var countryFromTextField: UITextField!
    @IBOutlet weak var cityFromTextField: UITextField!
    @IBOutlet weak var countryToTextField: UITextField!
    @IBOutlet weak var cityToTextField: UITextField!
    @IBOutlet weak var dateEarliestTextField: UITextField!
    @IBOutlet weak var dateLatestTextField: UITextField!
    @IBOutlet weak var taxFreeBtn: UIButton!
    @IBOutlet weak var taobaoBtn: UIButton!
    @IBOutlet weak var buyBtn: UIButton!
    @IBOutlet weak var oneCaseBtn: UIButton!
    @IBOutlet weak var bulkBtn: UIButton!
    
    var fromCountryPicker: UIPickerView! = UIPickerView()
    var toCountryPicker: UIPickerView! = UIPickerView()
    var fromCityPicker: UIPickerView! = UIPickerView()
    var toCityPicker: UIPickerView! = UIPickerView()
    var dateEarliestPicker: UIDatePicker! = UIDatePicker()
    var dateLatestPicker: UIDatePicker! = UIDatePicker()
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
        
        self.dateEarliestPicker.locale = NSLocale.init(localeIdentifier: "zh-Hans") as Locale
        self.dateEarliestPicker.datePickerMode = UIDatePickerMode.date
        
        self.dateEarliestPicker.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        self.dateEarliestPicker.tag = 0
        
        self.dateLatestPicker.locale = NSLocale.init(localeIdentifier: "zh-Hans") as Locale
        self.dateLatestPicker.datePickerMode = UIDatePickerMode.date
        
        self.dateLatestPicker.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        self.dateLatestPicker.tag = 1
        
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
        
        self.countryFromTextField.inputView = self.fromCountryPicker
        countryFromTextField.inputAccessoryView = toolBar
        self.countryToTextField.inputView = self.toCountryPicker
        self.countryToTextField.inputAccessoryView = toolBar
        self.dateEarliestTextField.inputView = self.dateEarliestPicker;
        self.dateLatestTextField.inputView = self.dateLatestPicker;
        self.cityFromTextField.delegate = self;
        self.cityToTextField.delegate = self;
        self.itemWeightTextField.delegate = self;
        
        itemNameTextfield.delegate = self;
        itemSizeTextField.delegate = self;
        itemWeightTextField.delegate = self;
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func donePicker(){
        
        self.countryFromTextField.resignFirstResponder();
        self.countryToTextField.resignFirstResponder();
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        dateFormatter.locale = NSLocale.init(localeIdentifier: "zh-Hans") as Locale
        if (sender.tag == 0) {
            self.dateEarliestTextField.text = dateFormatter.string(from: sender.date)
        } else {
            self.dateLatestTextField.text = dateFormatter.string(from: sender.date)
        }
        
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
                self.countryFromTextField.text = self.countryArray[row]
            } else if (pickerView.tag == PICKERS.TOCOUNTRY.hashValue) {
                self.countryToTextField.text = self.countryArray[row]
            }
        } else {
            print("City picker")
            if (pickerView.tag == PICKERS.FROMCOUNTRY.hashValue) {
                self.cityFromTextField.text = self.currentCityArray[row]
            } else if (pickerView.tag == PICKERS.TOCOUNTRY.hashValue) {
                self.cityToTextField.text = self.currentCityArray[row]
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
        
        if (self.countryFromTextField.text == "" || self.countryToTextField.text == "" || self.cityToTextField.text == "" || self.cityFromTextField.text == "" || self.dateEarliestTextField.text == "" || self.dateLatestTextField.text == "" || self.itemNameTextfield.text == "" || self.itemSizeTextField.text == "" || self.itemWeightTextField.text == "") {
            let alertController = UIAlertController(title: "Error", message: "Required field cannot be empty", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            }
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            var availableService = "";
            if (buyBtn.isSelected) {
                availableService = "代买物品"
            } else if (taxFreeBtn.isSelected) {
                availableService = "代免税店"
            } else if (taobaoBtn.isSelected) {
                availableService = "代收淘宝"
            }
            var avaliblePackage = "";
            if (bulkBtn.isSelected) {
                avaliblePackage = "散件"
            } else if (oneCaseBtn.isSelected) {
                avaliblePackage = "整箱"
            }
            var ref: DocumentReference? = nil
            ref = db.collection("requestListing").addDocument(data: [
                "packageType": avaliblePackage,
                "serviceType":availableService,
                "itemInfo":  ["weight": itemWeightTextField.text, "size": itemSizeTextField.text, "generalInfo": itemNameTextfield.text],
                "travelInfo": ["fromCountry": countryFromTextField.text, "fromCity": cityFromTextField.text, "toCountry": countryToTextField.text, "toCity": cityToTextField.text, "latestLimitTime": dateLatestTextField.text, "earliestLimitTIme": dateEarliestTextField.text],
                "userInfo": ["userId":  UserDefaults.standard.string(forKey: "userId"), "userName":  UserDefaults.standard.string(forKey: "nickName")]
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                    
                    let userIdref = self.db.collection("users").document(UserDefaults.standard.string(forKey: "userId")!)
                    
                    userIdref.getDocument { (document, error) in
                        if let document = document, document.exists {
                            var requestIdArray = document.data()!["requestIds"] as! [String]
                            
                            requestIdArray.append(ref!.documentID);
                            
                            userIdref.updateData([
                                "requestIds": requestIdArray
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
            self.taobaoBtn.isSelected = false
            self.buyBtn.isSelected = false
        }else {
            self.taxFreeBtn.isSelected = true
            self.taobaoBtn.isSelected = false
            self.buyBtn.isSelected = false
        }
    }
    
    @IBAction func taobaoBtnPressed(_ sender: Any) {
        if self.taobaoBtn.isSelected == true {
            self.taxFreeBtn.isSelected = false
            self.taobaoBtn.isSelected = false
            self.buyBtn.isSelected = false
        }else {
            self.taobaoBtn.isSelected = true
            self.taxFreeBtn.isSelected = false
            self.buyBtn.isSelected = false
        }
    }
    
    @IBAction func buyBtnPressed(_ sender: Any) {
        if self.buyBtn.isSelected == true {
            self.taxFreeBtn.isSelected = false
            self.taobaoBtn.isSelected = false
            self.buyBtn.isSelected = false
        }else {
            self.buyBtn.isSelected = true
            self.taobaoBtn.isSelected = false
            self.taxFreeBtn.isSelected = false
        }
    }
    @IBAction func oneCaseBtnPressed(_ sender: Any) {
        if self.oneCaseBtn.isSelected == true {
            self.oneCaseBtn.isSelected = false
            self.bulkBtn.isSelected = false
        }else {
            self.oneCaseBtn.isSelected = true
            self.bulkBtn.isSelected = false
        }
    }
    @IBAction func bulkBtnPressed(_ sender: Any) {
        if self.bulkBtn.isSelected == true {
            self.bulkBtn.isSelected = false
        }else {
            self.bulkBtn.isSelected = true
            self.oneCaseBtn.isSelected = false
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
