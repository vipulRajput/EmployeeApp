//
//  AddEmployeeVC.swift
//  EmployeeApp
//
//  Created by Vipul Kumar on 12/01/20.
//  Copyright © 2020 Vipul Kumar. All rights reserved.
//

import UIKit
import RxSwift

class AddEmployeeVC: UIViewController {

    enum AddEmployeeVCSetup {
        case AddEmployee, SelectCity
    }
    
    @IBOutlet weak var addEmployeeTableView: UITableView!
    
    let datePicker = UIDatePicker()
    var addEmployeeVCSetup: AddEmployeeVCSetup = .AddEmployee
    var isMarried = false
    let cities: [String] = ["Delhi", "Bengaluru", "Hyderabad", "Mumbai", "Pune", "Kolkata"]
    var enterdInfo = [String:String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initialSetup()
    }
    
    @IBAction func addEmployeeBtnTapped(_ sender: UIButton) {
        
        var employeeModel = Employee()
        
        employeeModel.name = self.enterdInfo["name"] ?? ""
        employeeModel.emailId = self.enterdInfo["emailId"] ?? ""
        employeeModel.city = self.enterdInfo["city"] ?? ""
        employeeModel.isMarried = self.isMarried
        employeeModel.anniversary = self.enterdInfo["anniversary"] ?? ""
        
        RxBus.shared.empAdded.onNext(employeeModel)
    }
}

extension AddEmployeeVC {
    
    fileprivate func initialSetup() {
        
        self.title = self.addEmployeeVCSetup == .AddEmployee ? "Add Employee" : "Select City"
        
        self.datePicker.datePickerMode = .date
        self.datePicker.setDate(Date(), animated: false)
        self.datePicker.maximumDate = Date()
        
        self.addEmployeeTableView.register(UINib(nibName: "EnterDetailsTableCell", bundle: nil), forCellReuseIdentifier: "EnterDetailsTableCell")
        self.addEmployeeTableView.dataSource = self
        self.addEmployeeTableView.delegate = self
    }
    
    @objc fileprivate func topicNameTextFieldEditingChanged(_ sender: UITextField) {
        
        guard let indexPath = sender.tableViewIndexPath(tableView: self.addEmployeeTableView) else {
            return
        }
        
        switch indexPath.row {
            
        case 1:
            self.enterdInfo["emailId"] = sender.text ?? ""
        case 2:
            self.enterdInfo["city"] = sender.text ?? ""
        default:
            self.enterdInfo["name"] = sender.text ?? ""
        }
    }
    
    @objc fileprivate func marriageStatusChanging(_ sender: UISwitch) {
        
        self.isMarried = sender.isOn
        self.addEmployeeTableView.reloadData()
    }
    
    @objc fileprivate func donedatePicker(_ sender: UIBarButtonItem) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        print(formatter.string(from: self.datePicker.date))
        
        self.enterdInfo["anniversary"] = formatter.string(from: self.datePicker.date)
        
        self.view.endEditing(true)
        self.addEmployeeTableView.reloadData()
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
}

extension AddEmployeeVC {
    
    fileprivate func enterDetailsTableCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EnterDetailsTableCell", for: indexPath) as? EnterDetailsTableCell else {
            fatalError("EnterDetailsTableCell not found!")
        }
        
        if self.addEmployeeVCSetup == .AddEmployee {
            cell.setupCell(row: indexPath.row, marriageStatusTrue: self.isMarried, empInfo: self.enterdInfo)
        } else {
            cell.setupCellFor(city: self.cities[indexPath.row])
        }
        
        if indexPath.row == 3 {
            
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
            
            doneButton.tintColor = UIColor.black
            cancelButton.tintColor = UIColor.black
            doneButton.tag = indexPath.row
            toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
            
            cell.enterTextField.inputAccessoryView = toolbar
            cell.enterTextField.inputView = datePicker
            
        } else {
            cell.enterTextField.inputView = nil
        }
        
        cell.enterTextField.reloadInputViews()
        cell.enterTextField.returnKeyType = .done
        cell.enterTextField.delegate = self
        cell.enterTextField.addTarget(self, action: #selector(topicNameTextFieldEditingChanged), for: .editingChanged)
        cell.marriageStatusSwitch.addTarget(self, action: #selector(marriageStatusChanging), for: .valueChanged)
        
        return cell
    }
}

extension AddEmployeeVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.addEmployeeVCSetup == .AddEmployee ? 4 : self.cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.enterDetailsTableCell(tableView, cellForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.addEmployeeVCSetup == .AddEmployee {
 
        } else {
            self.dismiss(animated: true, completion: nil)
        }
        
        // deselect
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension AddEmployeeVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        guard let indexPath = textField.tableViewIndexPath(tableView: self.addEmployeeTableView) else {
            return
        }
        
        if indexPath.row == 2 {
            
            self.view.endEditing(true)
            
            let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddEmployeeVC") as! AddEmployeeVC
            obj.addEmployeeVCSetup = .SelectCity
            let navController = UINavigationController(rootViewController: obj)
            self.navigationController?.present(navController, animated: true, completion: nil)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if range.location == 0 && string == " " {
            return false
        }
        if range.length == 1 {
            return true
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

