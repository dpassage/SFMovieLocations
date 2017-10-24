//
//  DetailViewController.swift
//  SFMovieLocations
//
//  Created by David Paschich on 10/19/17.
//  Copyright © 2017 David Paschich. All rights reserved.
//

import MapKit
import UIKit

let sanFranciscoRegion = MKCoordinateRegion(
    center: CLLocationCoordinate2D(latitude: 37.75471691847352, longitude: -122.43613515844427),
    span: MKCoordinateSpan(latitudeDelta: 0.21977110363538088, longitudeDelta: 0.17286470322854086)
)

class LocationMapViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!

    var viewModel: LocationMapViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        map.delegate = self
        map.setRegion(sanFranciscoRegion, animated: false)
        viewModel?.delegate = self
        updateMap()
    }

    func updateMap() {
        let currentAnnotations = map.annotations
        map.removeAnnotations(currentAnnotations)
        if let newAnnoation = viewModel?.mapAnnotation {
            map.addAnnotation(newAnnoation)
        }
        if let movieTitle = viewModel?.movieLocation.title {
            self.navigationItem.title = movieTitle
        }
    }
}

extension LocationMapViewController: LocationMapViewModelDelegate {
    func locationMapDidResolveLocation(viewModel: LocationMapViewModel) {
        updateMap()
    }
}

extension LocationMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let region = mapView.region
        NSLog("region is \(region)")
    }
}
