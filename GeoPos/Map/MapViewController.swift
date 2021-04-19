//
//  MapViewController.swift
//  GeoPos
//
//  Created by Matthew on 06.04.2021.
//  Copyright (c) 2021 Ostagram Inc.. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import GoogleMaps


protocol MapDisplayLogic: class {
    func updateScene(viewModel: MapModel.ViewModel)
}

class MapViewController: UIViewController, MapDisplayLogic {
    var interactor: MapBusinessLogic?
    var route: GMSPolyline?
    var onLogout: (() -> Void)?
    
    // MARK: Object lifecycle
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        route = GMSPolyline()
        route?.map = mapView
    }
    
    // MARK: Do something
    
    //@IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var stopBtn: UIButton!
    
    
    @IBAction func startBtnClick(_ sender: Any) {
        interactor?.startTracking(request: .init())
    }
    
    @IBAction func stopBtnClick(_ sender: Any) {
        interactor?.stopTracking(request: .init())
    }
    
    @IBAction func loadBtnClick(_ sender: Any) {
        interactor?.loadTrack(request: .init())
    }
    
    @IBAction func signoutBtnClick(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isLogin")
        onLogout?()
    }
    
    func updateScene(viewModel: MapModel.ViewModel) {
        self.startBtn.isEnabled = viewModel.startBtnEnable
        self.stopBtn.isEnabled = viewModel.stopBtnEnable
        if let routePath = viewModel.routePath {
            self.route?.path = routePath
        }
        if let camera = viewModel.cameraUpdate {
            self.mapView.animate(with: camera)
        }
    }
}
