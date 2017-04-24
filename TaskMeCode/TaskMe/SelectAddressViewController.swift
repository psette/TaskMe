//
//  SelectAddressViewController.swift
//  TaskMe
//
//  Created by Pietro Sette on 4/20/17.
//  Copyright © 2017 Pietro Sette. All rights reserved.
//

import UIKit
import MapKit


class SelectAddressViewController: UIViewController, CLLocationManagerDelegate{
    
    var resultSearchController:UISearchController? = nil

    let locationManager = CLLocationManager()
    
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // Do any additional setup after loading the view.
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
            resultSearchController = UISearchController(searchResultsController: locationSearchTable)
            resultSearchController?.searchResultsUpdater = locationSearchTable

            let searchBar = resultSearchController!.searchBar
            searchBar.sizeToFit()
            searchBar.placeholder = "Search for places"
            navigationItem.titleView = resultSearchController?.searchBar
            resultSearchController?.hidesNavigationBarDuringPresentation = false
            resultSearchController?.dimsBackgroundDuringPresentation = true
            definesPresentationContext = true
            locationSearchTable.mapView = mapView
        }

    }
    

     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
}
