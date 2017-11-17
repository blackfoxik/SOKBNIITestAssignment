//
//  TestObjectSearchViewObserverProtocol.swift
//  SOKBNIITestAssignment
//
//  Created by Anton on 17.11.17.
//  Copyright © 2017 Anton. All rights reserved.
//

import Foundation
protocol TestObjectSearchViewObserver {
    var view: TestObjectSearchViewObservable? { get set }
    
    func getTestObjects() -> [TestObject]
    func refresh()
    func pullToRefresh(completion: @escaping () -> ())
    func applyFilterToTestObjects(with text: String)
    func detailViewShouldReceiveTestObject(at row: Int)
}
