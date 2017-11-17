//
//  TestObjectViewObservableProtocol.swift
//  SOKBNIITestAssignment
//
//  Created by Anton on 15.11.17.
//  Copyright © 2017 Anton. All rights reserved.
//

import Foundation
protocol TestObjectSearchViewObservable {
    func updateUI()
    func detailViewRequestedNextTestObject()
    func detailViewRequestedPreviousTestObject()
}


