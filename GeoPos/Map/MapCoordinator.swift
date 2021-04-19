//
//  MapCoordinator.swift
//  GeoPos
//
//  Created by Matthew on 09.04.2021.
//  Copyright © 2021 Ostagram Inc. All rights reserved.
//

import UIKit
import CoreLocation

final class MapCoordinator: BaseCoordinator {
    
    var rootController: UIViewController?
    var onFinishFlow: (() -> Void)?
    
    override func start() {
        showMapModule()
    }
    
    private func showMapModule() {
        let controller = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(MapViewController.self)
        
        controller.onLogout = { [weak self] in
            self?.onFinishFlow?()
        }
        
        let viewController = controller
        let interactor = MapInteractor()
        let presenter = MapPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        interactor.dbService = RealmService.shared
        interactor.locationManager = CLLocationManager()
        presenter.viewController = viewController
        
        setAsRoot(controller)
        self.rootController = controller
    }
    
}
