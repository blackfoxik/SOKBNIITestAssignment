//
//  TestObjectDetailViewObservableProtocol.swift
//  SOKBNIITestAssignment
//
//  Created by Anton on 16.11.17.
//  Copyright © 2017 Anton. All rights reserved.
//

import Foundation
protocol TestObjectDetailViewObservable {
    func clearUI()
    func set(testObject: TestObject)
}
