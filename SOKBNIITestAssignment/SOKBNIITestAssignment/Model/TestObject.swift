//
//  TestObject.swift
//  SOKBNIITestAssignment
//
//  Created by Anton on 15.11.17.
//  Copyright © 2017 Anton. All rights reserved.
//
import UIKit
import Foundation
class TestObject {
    let id: Int
    let title: String
    let imgStringUrl: String
    var img: UIImage?
    init(id: Int, title: String, imgStringUrl: String) {
        self.id = id
        self.title = title
        self.imgStringUrl = imgStringUrl
    }
}

