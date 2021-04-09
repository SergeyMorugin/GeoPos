//
//  AuthCoordinator.swift
//  GeoPos
//
//  Created by Matthew on 09.04.2021.
//  Copyright © 2021 Ostagram Inc. All rights reserved.
//

import UIKit


final class AuthCoordinator: BaseCoordinator {
    
    var rootController: UIViewController?
    var onFinishFlow: (() -> Void)?
    
    override func start() {
        showAuthModule()
    }
    
    private func showAuthModule() {
        let controller = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(AuthViewController.self)
        
        controller.onLogin = { [weak self] in
            self?.onFinishFlow?()
        }
        
        controller.storeService = RealmService.shared

        setAsRoot(controller)
        self.rootController = controller
    }
    
}

