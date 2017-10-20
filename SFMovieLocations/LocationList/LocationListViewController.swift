//
//  LocationListViewController.swift
//  SFMovieLocations
//
//  Created by David Paschich on 10/19/17.
//  Copyright © 2017 David Paschich. All rights reserved.
//

import UIKit

class LocationListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var viewModel: LocationListViewModel = LocationListViewModel()

    var locations: [MovieLocationRecord] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NSLog("refreshing view model")
        viewModel.refresh()
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
                controller.detailItem = location
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
}

extension LocationListViewController: LocationListViewModelDelegate {
    func viewModel(_: LocationListViewModel, updatedLocations: [MovieLocationRecord]) {
        NSLog("in updatedLocations")
        locations = updatedLocations
        tableView.reloadData()
    }

    func viewModel(_: LocationListViewModel, error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}

extension LocationListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? locations.count : 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationListCell", for: indexPath)

        if locations.indices.contains(indexPath.row) {
            let location = locations[indexPath.row]
            cell.textLabel?.text = "\(location.title) (\(location.releaseYear))"
            cell.detailTextLabel?.text = location.location
        }

        return cell
    }
}
