//
//  TestObjectDataProviderService.swift
//  SOKBNIITestAssignment
//
//  Created by Anton on 15.11.17.
//  Copyright © 2017 Anton. All rights reserved.
//

import Foundation

class TestObjectDataProviderService: TestObjectDataProviderServiceProvider {
    var dataProvider: TestObjectDataProvider
    
    init (dataProvider: TestObjectDataProvider) {
        self.dataProvider = dataProvider
    }
    
    func getTestObjectList(completion: @escaping ([TestObject]) -> Void) {
        dataProvider.getTestObjectList(completion: completion)
    }
}

