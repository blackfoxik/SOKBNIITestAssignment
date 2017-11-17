//
//  TestObjectDataProviderServiceProviderProtocol.swift
//  SOKBNIITestAssignment
//
//  Created by Anton on 16.11.17.
//  Copyright © 2017 Anton. All rights reserved.
//

import Foundation

protocol TestObjectDataProviderServiceProvider {
    var dataProvider: TestObjectDataProvider { get set }
    func getTestObjectList(completion: @escaping ([TestObject]) -> Void)
}
