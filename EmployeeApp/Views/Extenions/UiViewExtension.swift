//
//  UiViewExtension.swift
//  EmployeeApp
//
//  Created by Vipul Kumar on 12/01/20.
//  Copyright © 2020 Vipul Kumar. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func tableViewCell() -> UITableViewCell? {
        
        var tableViewcell : UIView? = self
        
        while(tableViewcell != nil) {
            
            if tableViewcell! is UITableViewCell {
                break
            }
            tableViewcell = tableViewcell!.superview
        }
        return tableViewcell as? UITableViewCell
    }
    
    
    func tableViewIndexPath(tableView: UITableView) -> NSIndexPath? {
        
        if let cell = self.tableViewCell() {
            return tableView.indexPath(for: cell) as NSIndexPath?
        }
        return nil
    }
}
