//
//  ImageDownloader.swift
//  SOKBNIITestAssignment
//
//  Created by Anton on 16.11.17.
//  Copyright © 2017 Anton. All rights reserved.
//

import Foundation
import UIKit

class ImageDownloader: ImageProviderService {
    var error = NSError(domain: "", code: 0, userInfo: nil)
    func getImageBy(urlString: String?, completion: @escaping ((UIImage?, NSError?)) -> ()) {
        if urlString != nil {
            let url = URL(string: urlString!)
            let queue = DispatchQueue.global(qos: .userInitiated)
            queue.async {
                if let data = try? Data(contentsOf: url!) {
                    let image = UIImage(data: data)
                    completion((image, nil))
                }
                else {
                    completion((nil, self.error))
                }
            }
        } else {
            completion((nil, error))
        }
    }
}
