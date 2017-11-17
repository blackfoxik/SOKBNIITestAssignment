//
//  TestObjectDetailViewObserverProtocol.swift
//  SOKBNIITestAssignment
//
//  Created by Anton on 17.11.17.
//  Copyright © 2017 Anton. All rights reserved.
//

import Foundation
protocol TestObjectDetailViewObserver {
    var detailView: TestObjectDetailViewObservable? { get set }
    
    func needNextTestObject()
    func needPreviousTestObject()
}
