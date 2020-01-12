//
//  RxBus.swift
//  EmployeeApp
//
//  Created by Vipul Kumar on 12/01/20.
//  Copyright © 2020 Vipul Kumar. All rights reserved.
//

import Foundation
import RxSwift

class RxBus: NSObject {
    
    static let shared = RxBus()
    
    private override init() { }

    var empAdded = PublishSubject<Employee>()
    var empUpdateClicked = PublishSubject<Employee>()
    var empUpdated = PublishSubject<Employee>()
    var empDeletedIndex = PublishSubject<Int>()
    var selectedCity = PublishSubject<String>()
}
