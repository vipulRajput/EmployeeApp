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
    
    var employees = PublishSubject<[Employee]>()
    
    func getEmployees() {
        
        let fetchRequest = NSFetchRequest<EmployeeEntity>(entityName: "EmployeeEntity")
        
        do {
            
            let employeesData = try managedContext.fetch(fetchRequest)
            var empArr = [Employee]()
            
            _ = employeesData.map({ (employeeEntity) in
                
                var employeeModel = Employee()
                
                employeeModel.name = employeeEntity.value(forKey: "name") as? String ?? ""
                employeeModel.emailId = employeeEntity.value(forKey: "emailId") as? String ?? ""
                employeeModel.city = employeeEntity.value(forKey: "city") as? String ?? ""
                employeeModel.isMarried = employeeEntity.value(forKey: "isMarried") as? Bool ?? false
                employeeModel.anniversary = employeeEntity.value(forKey: "anniversary") as? String ?? ""
                
                print(employeeEntity.value(forKey: "name") as? String ?? "")
                empArr.append(employeeModel)
            })
            self.employees.onNext(empArr)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func addEmployee(employee: Employee) {
        
        let context = EmployeeEntity(context: managedContext)
        context.setValue(employee.name, forKey: "name")
        context.setValue(employee.emailId, forKey: "emailId")
        context.setValue(employee.city, forKey: "city")
        context.setValue(employee.isMarried, forKey: "isMarried")
        context.setValue(employee.anniversary, forKey: "anniversary")
        
        do {
            try managedContext.save()
            
            self.employees.onNext([employee])
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func updateEmployee(employee: Employee) {
        
        let fetchRequest = NSFetchRequest<EmployeeEntity>(entityName: "EmployeeEntity")
        
        do {
            let employeesData = try managedContext.fetch(fetchRequest)
            
            let requiredEmployee = employeesData.filter { (employeeEntity) -> Bool in
                return employee.emailId == (employeeEntity.value(forKey: "emailId") as? String ?? "")
            }
            if let employeeToUpdate = requiredEmployee.first {
                
                employeeToUpdate.setValue(employee.name, forKey: "name")
                employeeToUpdate.setValue(employee.emailId, forKey: "emailId")
                employeeToUpdate.setValue(employee.city, forKey: "city")
                employeeToUpdate.setValue(employee.isMarried, forKey: "isMarried")
                employeeToUpdate.setValue(employee.anniversary, forKey: "anniversary")
            }
            do {
                try managedContext.save()
                RxBus.shared.empUpdated.onNext(employee)
            } catch  let error as NSError {
                print("Could not update. \(error), \(error.userInfo)")
            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func deleteEmployeeOf(index: Int) {
        
        let fetchRequest = NSFetchRequest<EmployeeEntity>(entityName: "EmployeeEntity")
        
        do {
            let employeesData = try managedContext.fetch(fetchRequest)
            
            let employeeToDelete = employeesData[index]
            managedContext.delete(employeeToDelete)
            
            do {
                try managedContext.save()
                RxBus.shared.empDeletedIndex.onNext(index)
            } catch  let error as NSError {
                print("Could not delete. \(error), \(error.userInfo)")
            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
