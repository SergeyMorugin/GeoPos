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
    weak var interactor: MapInteractor?
    var onFinishFlow: (() -> Void)?
    
    override func start() {
        showMapModule()
    }
    
    private func showMapModule() {
        let controller = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(MapViewController.self)
        
        controller.onLogout = { [weak self] in
            UserDefaults.standard.set(false, forKey: "isLogin")
            self?.onFinishFlow?()
        }
        
        controller.onMakeAvatar = { [weak self] in
            self?.toPhoto()
        }
        
        let viewController = controller
        let interactor = MapInteractor()
        let presenter = MapPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        interactor.dbService = RealmService.shared
        interactor.locationManager = CLLocationManager()
        presenter.viewController = viewController
        self.interactor = interactor
        setAsRoot(controller)
        self.rootController = controller
    }
    
    private func toPhoto() {
        let coordinator = PhotoCoordinator()
        
        coordinator.onFinishFlow = { [weak self, weak coordinator] image in
            self?.removeDependency(coordinator)
            self?.interactor?.updateAvatatar(image: image)
        }
        addDependency(coordinator)
        coordinator.start()
    }

    
}
