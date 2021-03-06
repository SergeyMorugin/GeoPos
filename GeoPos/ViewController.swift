//
//  ViewController.swift
//  GeoPos
//
//  Created by Matthew on 01.04.2021.
//  Copyright © 2021 Ostagram Inc. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation


class ViewController: UIViewController {
    let mapCameraZoom: Float = 15
    var locationManager: CLLocationManager?
    
    
    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
         configureLocationManager()
    }
    
    func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation()
    }
    
    func goTo(coordinate: CLLocationCoordinate2D){
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: mapCameraZoom)
        mapView.animate(to: camera)
    }
    
    func addMarker(coordinate: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: coordinate)
        marker.map = mapView
    }


}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        print(location)
        goTo(coordinate: location.coordinate)
        addMarker(coordinate: location.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print(error)
    }
}
