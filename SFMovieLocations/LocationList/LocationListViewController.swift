//
//  LocationListViewController.swift
//  SFMovieLocations
//
//  Created by David Paschich on 10/19/17.
//  Copyright © 2017 David Paschich. All rights reserved.
//

import UIKit

class LocationListViewController: UITableViewController {

    var viewModel: LocationListViewModel = LocationListViewModel()

    var locations: [MovieLocationRecord] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self
        refreshControl?.addTarget(self,
                                  action: #selector(LocationListViewController.handleRefresh(refreshControl:)),
                                  for: .valueChanged)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow,
                locations.indices.contains(indexPath.row) {
                let location = locations[indexPath.row]
                guard let controller = (segue.destination as? UINavigationController)?.topViewController
                    as? LocationMapViewController else {
                    return
                }
                controller.viewModel = LocationMapViewModel(movieLocation: location)
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    @objc func handleRefresh(refreshControl: UIRefreshControl) {
        viewModel.refresh()
    }

    @IBAction func showSortSelector(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Sort By", message: nil, preferredStyle: .actionSheet)
        let titleAction = UIAlertAction(title: "Title", style: .default) { (_) in
            self.viewModel.sortOrder = .byTitle
        }
        alert.addAction(titleAction)
        let yearAction = UIAlertAction(title: "Year", style: .default) { (_) in
            self.viewModel.sortOrder = .byYear
        }
        alert.addAction(yearAction)
        present(alert, animated: true)
    }
}

extension LocationListViewController: LocationListViewModelDelegate {
    func viewModel(_: LocationListViewModel, updatedLocations: [MovieLocationRecord]) {
        NSLog("in updatedLocations")
        locations = updatedLocations
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }

    func viewModel(_: LocationListViewModel, error: Error) {
        refreshControl?.endRefreshing()
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension LocationListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? locations.count : 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationListCell", for: indexPath)

        if locations.indices.contains(indexPath.row) {
            let location = locations[indexPath.row]
            cell.textLabel?.text = "\(location.title) (\(location.releaseYear))"
            cell.detailTextLabel?.text = location.location
        }

        return cell
    }
}
