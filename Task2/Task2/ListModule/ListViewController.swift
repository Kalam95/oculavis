//
//  ListViewController.swift
//  Task2
//
//  Created by IT Devices In House on 10.06.21.
//

import UIKit

class ListViewController: BaseViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: ListViewModel! // viewModel
    private var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsAtViewDidLoad()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.contentInset = UIEdgeInsets(top: self.containerView.frame.height - 80,// ay random size
                                              left: 0,
                                              bottom: 0,
                                              right: 0)
    }

    private func settingsAtViewDidLoad() {
        setUPUI()
        viewModel.sendRequest()
        viewModel.signal.subscribe { [weak self] _ in
            self?.updateUI()
        } onError: { [weak self] error in
            self?.showAlert(title: "Failure!!", description: error.errorMessage, primaryAction: ("OK", {[weak self] in
                self?.navigationController?.popViewController(animated: true)
            }))
        }
    }

    private func setSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        self.definesPresentationContext = true
        self.navigationItem.titleView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
    }

    private func setUPUI() {
        setSearchBar()
        containerView.backgroundColor = .lightRedColor()
        tableView.registerCell(type: PokemonCell.self)
        tableView.rowHeight = .minRelative(size: 140)
    }

    private func updateUI() {
        countLabel.text = viewModel.countString()
        tableView.reloadData()
    }

}

//MARK: Table view data scource and delegate handling
extension ListViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSection()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PokemonCell = tableView.dequeueTypedCell(for: indexPath)
        cell.populateCell(with: viewModel.data(forRowAt: indexPath))
        return cell
    }
}

extension ListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            viewModel.filterResult(searchText: searchText)
            tableView.reloadData()
        }
    }
}
