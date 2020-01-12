//
//  EmployeesListVC.swift
//  EmployeeApp
//
//  Created by Vipul Kumar on 12/01/20.
//  Copyright © 2020 Vipul Kumar. All rights reserved.
//

import UIKit
import RxSwift

class EmployeesListVC: UIViewController {

    @IBOutlet weak var employeeListTableView: UITableView!
    
    let disposeBag = DisposeBag()
    var employeeVM = EmployeeViewModel()
    var employeeList = [Employee]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initialSetup()
    }
    
    
}

extension EmployeesListVC {
    
    fileprivate func initialSetup() {
        
        self.title = "Employee List"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addEmployee))
        
        self.employeeListTableView.register(UINib(nibName: "EmployeeTableCell", bundle: nil), forCellReuseIdentifier: "EmployeeTableCell")
        self.employeeListTableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        self.employeeListTableView.tableFooterView = UIView()
        self.employeeListTableView.dataSource = self
        self.employeeListTableView.delegate = self
        
        self.observeViewModelChanges()
    }
    
    fileprivate func observeViewModelChanges() {
        
        self.employeeVM.employees
        .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
        .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (employees) in
                
                print("on Next\n")
                print(employees)
                
            }, onError: { (error) in
                print(error.localizedDescription)
            }, onCompleted: nil, onDisposed: nil)
        .disposed(by: self.disposeBag)
        
        RxBus.shared.empAdded
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (employee) in
                
                print("on Next\n")
                print("employee added")
                
            }, onError: { (error) in
                print(error.localizedDescription)
            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)
        
    }
    
    @objc fileprivate func addEmployee(_ sender: UIBarButtonItem) {
        
        let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddEmployeeVC") as! AddEmployeeVC
        self.navigationController?.pushViewController(obj, animated: true)
    }
}

extension EmployeesListVC {
    
    fileprivate func employeeTableCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeTableCell", for: indexPath) as? EmployeeTableCell else {
            fatalError("EmployeeTableCell not found!")
        }
        
        return cell
    }
}

extension EmployeesListVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.employeeTableCell(tableView, cellForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
