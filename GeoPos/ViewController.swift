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
    
    var route: GMSPolyline?
    var routePath: GMSMutablePath?
    
    var dbService: DBService?
    
    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dbService = RealmService()
        configureLocationManager()
    }
    
    func initRoutePath(){
        route?.map = nil
        route = GMSPolyline()
        routePath?.removeAllCoordinates()
        routePath = GMSMutablePath()
        route?.map = mapView
    }
    
    func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        //locationManager?.stopUpdatingLocation()
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.pausesLocationUpdatesAutomatically = false
        locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager?.requestAlwaysAuthorization()
        
    }
    
    func goTo(coordinate: CLLocationCoordinate2D){
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: mapCameraZoom)
        mapView.animate(to: camera)
    }
    
    func addMarker(coordinate: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: coordinate)
        marker.map = mapView
    }
    
    func addPathPoint(coordinate: CLLocationCoordinate2D) {
        routePath?.add(coordinate)
        route?.path = routePath
    }
    
    func pathToCoordinates() -> [Coordinate]{
        guard
            let path = routePath,
            let count = routePath?.count()
        else { return [] }
        let result = NSMutableArray()
        for i in 0..<count {
            let c = path.coordinate(at: i)
            result.add(Coordinate(latitude: c.latitude, longitude: c.longitude))
        }
        return Array(_immutableCocoaArray: result)
    }
    
    
    
    @IBAction func startBtnClick(_ sender: Any) {
        initRoutePath()
        locationManager?.startUpdatingLocation()
        //locationManager?.startMonitoringSignificantLocationChanges()
    }
    
    @IBAction func stopBtnClick(_ sender: Any) {
        locationManager?.stopUpdatingLocation()
        locationManager?.stopMonitoringSignificantLocationChanges()
        dbService?.purgeCoordinates()
        dbService?.save(coordinates: pathToCoordinates())
    }
    
    @IBAction func loadBtnClick(_ sender: Any) {
        locationManager?.stopUpdatingLocation()
        locationManager?.stopMonitoringSignificantLocationChanges()
        let coordinates = dbService?.fetchCoordinates()
        initRoutePath()
        coordinates?.forEach({
            routePath?.add(CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude))
        })
        route?.path = routePath
        let bounds = coordinates?.reduce(GMSCoordinateBounds()) {
            $0.includingCoordinate(CLLocationCoordinate2D(latitude: $1.latitude, longitude: $1.longitude))
        }

        mapView.animate(with: .fit(bounds!, withPadding: 30.0))
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        print(location)
        goTo(coordinate: location.coordinate)
        addPathPoint(coordinate: location.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print(error)
    }
}
