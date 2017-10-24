//
//  LocationMapViewModel.swift
//  SFMovieLocations
//
//  Created by David Paschich on 10/23/17.
//  Copyright © 2017 David Paschich. All rights reserved.
//

import Foundation
import MapKit

class MovieLocationAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?

    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}

protocol LocationMapViewModelDelegate: class {
    func locationMapDidResolveLocation(viewModel: LocationMapViewModel)
}

class LocationMapViewModel {
    weak var delegate: LocationMapViewModelDelegate?

    let movieLocation: MovieLocationRecord

    var mapAnnotation: MKAnnotation?

    init(movieLocation: MovieLocationRecord) {
        self.movieLocation = movieLocation
        resolveLocation()
    }

    private func resolveLocation() {
        guard let location = movieLocation.location else { return }
        let funFact = movieLocation.funFact
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = location
        request.region = sanFranciscoRegion

        let search = MKLocalSearch(request: request)
        search.start { (response, _) in
            if let response = response,
                let item = response.mapItems.first {
                self.mapAnnotation =
                    MovieLocationAnnotation(coordinate: item.placemark.coordinate, title: location, subtitle: funFact)
                self.delegate?.locationMapDidResolveLocation(viewModel: self)
            }
        }
    }
}
