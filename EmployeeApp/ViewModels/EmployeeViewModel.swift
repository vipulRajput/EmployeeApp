//
//  EmployeeViewModel.swift
//  EmployeeApp
//
//  Created by Vipul Kumar on 12/01/20.
//  Copyright © 2020 Vipul Kumar. All rights reserved.
//

import Foundation
import RxSwift
import CoreData

class EmployeeViewModel {
    
    var employees = PublishSubject<Employee>()
    
    func getEmployees() {
        
        let fetchRequest = NSFetchRequest<EmployeeEntity>(entityName: "EmployeeEntity")
        
        do {
            
            let employeesData = try managedContext.fetch(fetchRequest)
            
            _ = employeesData.map({ (employeeEntity) in
                
                var employeeModel = Employee()
                
                employeeModel.name = employeeEntity.value(forKey: "name") as? String ?? ""
                employeeModel.emailId = employeeEntity.value(forKey: "emailId") as? String ?? ""
                employeeModel.city = employeeEntity.value(forKey: "city") as? String ?? ""
                employeeModel.isMarried = employeeEntity.value(forKey: "isMarried") as? Bool ?? false
                employeeModel.anniversary = employeeEntity.value(forKey: "anniversary") as? String ?? ""
                
                self.employees.onNext(employeeModel)
            })
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func addEmployee() {
        
        
    }
    
    func updateEmployee() {
        
        
    }
    
    func deleteEmployees() {
        
        
    }
}
