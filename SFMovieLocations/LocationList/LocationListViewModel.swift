//
//  LocationListViewModel.swift
//  SFMovieLocations
//
//  Created by David Paschich on 10/19/17.
//  Copyright © 2017 David Paschich. All rights reserved.
//

import Foundation

protocol LocationListViewModelDelegate: class {
    func viewModel(_: LocationListViewModel, updatedLocations: [MovieLocationRecord])
    func viewModel(_: LocationListViewModel, error: Error)
}

class LocationListViewModel {
    enum SortOrder {
        case byTitle
        case byYear
    }

    var sortOrder: SortOrder = .byTitle {
        didSet {
            if oldValue != sortOrder {
                sortMovies()
                delegate?.viewModel(self, updatedLocations: locations)
            }
        }
    }
    weak var delegate: LocationListViewModelDelegate?

    var locations: [MovieLocationRecord] = []
    fileprivate let locationService: MovieLocationService

    init(locationService: MovieLocationService = MovieLocationService()) {
        self.locationService = locationService
        refresh()
    }

    func refresh() {
        NSLog("refresh called")
        locationService.getMovieLocations { (result) in
            switch result {
            case .some(let apiResult):
                NSLog("got \(apiResult.movieLocations.count) results")
                self.locations = apiResult.movieLocations
                self.sortMovies()
                self.delegate?.viewModel(self, updatedLocations: apiResult.movieLocations)
            case .error(let error):
                NSLog("error! \(error)")
                self.delegate?.viewModel(self, error: error)
            }
        }
    }

    private func sortMovies() {
        switch sortOrder {
        case .byTitle:
            locations.sort { (left, right) -> Bool in
                if left.title == right.title {
                    return left.releaseYear < right.releaseYear
                }
                return left.title < right.title
            }
        case .byYear:
            locations.sort { (left, right) -> Bool in
                if left.releaseYear == right.releaseYear {
                    return left.title < right.title
                }
                return left.releaseYear < right.releaseYear
            }
        }
    }
}
