//
//  ImageProviderServiceProtocol.swift
//  SOKBNIITestAssignment
//
//  Created by Anton on 16.11.17.
//  Copyright © 2017 Anton. All rights reserved.
//

import Foundation
import UIKit
protocol ImageProviderService {
    func getImageBy(urlString: String?, completion: @escaping ((UIImage?, NSError?)) -> ())
}
