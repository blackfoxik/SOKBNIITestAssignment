//
//  Presenter.swift
//  SOKBNIITestAssignment
//
//  Created by Anton on 15.11.17.
//  Copyright © 2017 Anton. All rights reserved.
//

import Foundation

class TestObjectPresenter {
    var view: TestObjectSearchViewObservable?
    var detailView: TestObjectDetailViewObservable?
    var testObjectFilteredlist = [TestObject]()
    
    private var testObjectList = [TestObject]()
    private var testObjectDataProviderService: TestObjectDataProviderServiceProvider
    
    init (testObjectDataProviderService: TestObjectDataProviderServiceProvider) {
        self.testObjectDataProviderService = testObjectDataProviderService
    }
}

extension TestObjectPresenter: TestObjectSearchViewObserver {
    
    func getTestObjects() -> [TestObject] {
        return testObjectFilteredlist
    }
    
    func refresh() {
        testObjectDataProviderService.getTestObjectList() { result in
            self.testObjectList = result
            self.testObjectFilteredlist = result
            self.view?.updateUI()
            self.detailView?.clearUI()
        }
    }
    
    func pullToRefresh(completion: @escaping () -> ()) {
        testObjectDataProviderService.getTestObjectList() { result in
            let newTestObjects = self.getTestObjectsThatUniqueInNewList(newTestObjectList: result,
                                                                        oldTestObjectList: self.testObjectList)
            if newTestObjects.count > 0 {
                self.testObjectList.insert(contentsOf: newTestObjects, at: 0)
            }
            self.detailView?.clearUI()
            completion()
        }
    }
    
    func applyFilterToTestObjects(with text: String) {
        if text != "" {
            testObjectFilteredlist = testObjectList.filter() {
                return $0.title.lowercased().range(of: text.lowercased()) != nil
            }
        } else {
            testObjectFilteredlist = testObjectList
        }
        self.detailView?.clearUI()
    }
    
    func detailViewShouldReceiveTestObject(at row: Int) {
        detailView?.set(testObject: testObjectFilteredlist[row])
    }

}

extension TestObjectPresenter: TestObjectDetailViewObserver {
    func needNextTestObject() {
        view?.detailViewRequestedNextTestObject()
    }
    
    func needPreviousTestObject() {
        view?.detailViewRequestedPreviousTestObject()
    }
}


extension TestObjectPresenter {
    private func getTestObjectsThatUniqueInNewList(newTestObjectList: [TestObject],
                                                   oldTestObjectList: [TestObject]) -> [TestObject] {
        var result = [TestObject]()
        var newListAsSetOfTitles: Set<String>? =  Set(newTestObjectList.map{$0.title})
        let oldListAsSetOfTitles: Set<String>? =  Set(oldTestObjectList.map{$0.title})
        if newListAsSetOfTitles != nil && oldListAsSetOfTitles != nil {
            newListAsSetOfTitles!.subtract(oldListAsSetOfTitles!)
            if newListAsSetOfTitles!.count > 0 {
                let arrayOfTitles = Array(newListAsSetOfTitles!)
                result = newTestObjectList.filter() {arrayOfTitles.contains($0.title) }
            }
        }
        return result
    }
}

