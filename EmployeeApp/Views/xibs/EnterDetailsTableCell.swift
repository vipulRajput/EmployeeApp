//
//  EnterDetailsTableCell.swift
//  EmployeeApp
//
//  Created by Vipul Kumar on 12/01/20.
//  Copyright © 2020 Vipul Kumar. All rights reserved.
//

import UIKit

class EnterDetailsTableCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var enterTextField: UITextField!
    @IBOutlet weak var marriageStatusSwitch: UISwitch!
    @IBOutlet weak var marriageTextFieldHeight: NSLayoutConstraint!
    
    let titleArr = ["Name", "Email Id", "City", "Married"]
    let placeholderArr = ["Enter name", "Enter email id", "Enter city", "Enter D.O.B"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initialSetup()
    }
}

extension EnterDetailsTableCell {
    
    fileprivate func initialSetup() {
        
        self.marriageStatusSwitch.isOn = false
    }
    
    func setupCell(row: Int, marriageStatusTrue: Bool) {
        
        self.titleLabel.text = self.titleArr[row]
        self.enterTextField.placeholder = self.placeholderArr[row]
        self.marriageStatusSwitch.isHidden = row != 3
        self.enterTextField.isHidden = row != 3 ? false : marriageStatusTrue ? false : true
        self.marriageTextFieldHeight.constant = row != 3 ? 40 : marriageStatusTrue ? 40 : 0
    }
    
    func setupCellFor(city: String) {
        
        self.titleLabel.font = UIFont.systemFont(ofSize: 16)
        self.titleLabel.text = city
        self.marriageStatusSwitch.isHidden = true
        self.enterTextField.isHidden = true
        self.marriageTextFieldHeight.constant = 0
    }
}
