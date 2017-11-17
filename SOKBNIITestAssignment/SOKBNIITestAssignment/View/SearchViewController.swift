//
//  ViewController.swift
//  SOKBNIITestAssignment
//
//  Created by Anton on 15.11.17.
//  Copyright © 2017 Anton. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var downloadingTestObjectsActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var testObjectTitleFilterSearchBar: UISearchBar!
    @IBOutlet weak var testObjectTableView: UITableView!
    
    var refreshControl: UIRefreshControl!
    private var presenter: TestObjectSearchViewObserver?
    private var testOjects = [TestObject]()
    
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        refreshPresenter()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testObjectTableView.dataSource = self
        testObjectTitleFilterSearchBar.delegate = self
        preparePresenter()
        setupRefreshControl()
    }
}

extension SearchViewController {
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(SearchViewController.pullToRefresh), for: UIControlEvents.valueChanged)
        testObjectTableView.addSubview(refreshControl)
    }
    
    private func preparePresenter () {
        let dataProvider = DataProvider()
        let serviceDataProvider = TestObjectDataProviderService(dataProvider: dataProvider)
        presenter = TestObjectPresenter(testObjectDataProviderService: serviceDataProvider) as? TestObjectSearchViewObserver
        presenter?.view = self
        refreshPresenter()
    }
    
    private func refreshPresenter() {
        downloadingTestObjectsActivityIndicator.startAnimating()
        presenter?.refresh()
    }
    
    @objc private func pullToRefresh() {
        presenter?.pullToRefresh() {
            DispatchQueue.main.async {
                sleep(1)
                self.updateUI()
                self.refreshControl.endRefreshing()
            }
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.applyFilterToTestObjects(with: searchText)
        testOjects = presenter!.getTestObjects()
        testObjectTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController: TestObjectSearchViewObservable {
    func detailViewRequestedNextTestObject() {
        let row = (testObjectTableView.indexPathForSelectedRow?.row)! + 1
        detailViewShouldReceiveTestObject(at: row)
    }
    
    func detailViewRequestedPreviousTestObject() {
        let row = (testObjectTableView.indexPathForSelectedRow?.row)! - 1
        detailViewShouldReceiveTestObject(at: row)
    }

    func updateUI() {
        DispatchQueue.main.async {
            let searchText = self.testObjectTitleFilterSearchBar?.text
            if searchText != nil && searchText != "" {
                self.presenter?.applyFilterToTestObjects(with: searchText!)
            }
            self.testOjects = self.presenter!.getTestObjects()
            self.testObjectTableView.reloadData()
            self.downloadingTestObjectsActivityIndicator.stopAnimating()
        }
    }
    
    private func detailViewShouldReceiveTestObject(at row: Int) {
        if row < 0 || row >= testOjects.count { return }
        
        let indexPath = IndexPath(row: row, section: DefaultsKeys.DEFAULT_SECTION_NUMBER)
        testObjectTableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
        
        presenter?.detailViewShouldReceiveTestObject(at: row)
    }
}

extension SearchViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == DefaultsKeys.DETAIL_INFO_SEGUE_ID {
            if let destination = segue.destination as? UINavigationController {
                if let detailVC = destination.visibleViewController as? TestObjectDetailInfoViewController {
                    if let indexPath = testObjectTableView.indexPathForSelectedRow {
                        detailVC.presenter = presenter as? TestObjectDetailViewObserver
                        detailVC.presenter?.detailView = detailVC
                        presenter?.detailViewShouldReceiveTestObject(at: indexPath.row)
                        
                        detailVC.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                        detailVC.navigationItem.leftItemsSupplementBackButton = true
                    }
                }
            }
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testOjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DefaultsKeys.TEST_OBJECT_CELL_ID, for: indexPath)
        cell.textLabel?.text = testOjects[indexPath.row].title
        return cell
    }
}

extension DefaultsKeys {
    static let TEST_OBJECT_CELL_ID: String = "TestObjectCell"
    static let DETAIL_INFO_SEGUE_ID: String = "TestObjectDetailInfo"
    static let DEFAULT_SECTION_NUMBER: Int = 0
}


