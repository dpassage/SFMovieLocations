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

    weak var delegate: LocationListViewModelDelegate?

    fileprivate let locationService: MovieLocationService

    init(locationService: MovieLocationService = MovieLocationService()) {
        self.locationService = locationService
    }

    func refresh() {
        NSLog("refresh called")
        locationService.getMovieLocations { (result) in
            switch result {
            case .some(let apiResult):
                NSLog("got \(apiResult.movieLocations.count) results")
                self.delegate?.viewModel(self, updatedLocations: apiResult.movieLocations)
            case .error(let error):
                NSLog("error! \(error)")
                self.delegate?.viewModel(self, error: error)
            }
        }
    }
}
