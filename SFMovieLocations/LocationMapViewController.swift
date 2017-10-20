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


    func configureView() {
        // Update the user interface for the detail item.
        if let location = detailItem?.location {
            let request = MKLocalSearchRequest()
            request.naturalLanguageQuery = location
            request.region = sanFranciscoRegion

            let search = MKLocalSearch(request: request)
            search.start(completionHandler: { (response, error) in
                if let response = response,
                    let item = response.mapItems.first {
                    self.map.addAnnotation(item.placemark)
                }
            })

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        map.delegate = self
        map.setRegion(sanFranciscoRegion, animated: false)
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: MovieLocationRecord? {
        didSet {
            // Update the view.
            configureView()
        }
    }
}

extension LocationMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let region = mapView.region
        NSLog("region is \(region)")
    }
}
