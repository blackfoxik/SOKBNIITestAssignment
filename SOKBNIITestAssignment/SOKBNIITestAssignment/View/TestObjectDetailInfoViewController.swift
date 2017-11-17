//
//  TestObjectDetailInfoViewController.swift
//  SOKBNIITestAssignment
//
//  Created by Anton on 16.11.17.
//  Copyright © 2017 Anton. All rights reserved.
//

import UIKit

class TestObjectDetailInfoViewController: UIViewController {
    
    var testObject: TestObject?
    var presenter: TestObjectDetailViewObserver?
    
    @IBOutlet weak var downloadingImageActivityIndicator: UIActivityIndicatorView!
    var imageDownloader: ImageProviderService?
    @IBOutlet weak var testObjectImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageDownloader = ImageDownloader()
        addGestures()
        showImage()
    }
    
}

extension TestObjectDetailInfoViewController {
    func updateUI() {
        self.title = testObject?.title
        showImage()
    }
}

extension TestObjectDetailInfoViewController {
    private func addGestures() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    @objc private func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == .right {
            //step to previous object
            showPreviousObject()
        }
        if gesture.direction == .left {
            //step to next object
            showNextObject()
        }
    }
    
    private func showPreviousObject() {
        presenter?.needPreviousTestObject()
    }
    
    private func showNextObject() {
        presenter?.needNextTestObject()
    }
    
}

extension TestObjectDetailInfoViewController: TestObjectDetailViewObservable {
    
    func set(testObject: TestObject) {
        self.testObject = testObject
        updateUI()
    }
    
    func clearUI() {
        DispatchQueue.main.async {
            self.testObject = nil
            self.title = ""
            self.testObjectImage.image = nil
        }
    }
}

extension TestObjectDetailInfoViewController {
    private func showImage() {
        if testObject != nil {
            downloadingImageActivityIndicator?.startAnimating()
            if testObject?.img == nil {
                downloadImage()
            } else {
                DispatchQueue.main.async {
                    self.testObjectImage.image = self.testObject?.img
                    self.downloadingImageActivityIndicator?.stopAnimating()
                }
            }
        }
    }
    
    private func downloadImage() {
        imageDownloader?.getImageBy(urlString: testObject?.imgStringUrl) { (downloadedImage, error) in
            var image = downloadedImage
            if image != nil {
                self.testObject?.img = image
            } else {
                //we can use placeholder
                //or show error that there is no image
                let placeholderImage = UIImage(named: DefaultsKeys.IMAGE_STUB_NAME)
                image = placeholderImage
            }
            DispatchQueue.main.async {
                self.testObjectImage.image = image
                self.downloadingImageActivityIndicator?.stopAnimating()
            }
        }
    }
}

extension DefaultsKeys {
    static let IMAGE_STUB_NAME = "NoImageAvailable.png"
}
