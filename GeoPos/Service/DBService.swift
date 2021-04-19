//
//  DBService.swift
//  GeoPos
//
//  Created by Matthew on 05.04.2021.
//  Copyright © 2021 Ostagram Inc. All rights reserved.
//

import Foundation
import RealmSwift

protocol DBService {
    func save(coordinates: [Coordinate])
    func fetchCoordinates() -> [Coordinate]
    func purgeCoordinates()
    
    func authUser(login: String, password: String) -> Bool
    func updateOrCreate(user: User) -> UserActionStatus
}

enum UserActionStatus {
    case created
    case updated
}

class RealmService: DBService {
    
    static var shared = RealmService()
    let localRealm = try! Realm()
    
    func save(coordinates: [Coordinate]) {
        guard coordinates.count > 0 else { return }
        try! localRealm.write {
            coordinates.forEach {
                localRealm.add($0)
            }
        }
    }
    
    func fetchCoordinates() -> [Coordinate] {
        let coordinates = localRealm.objects(Coordinate.self)
        return Array(coordinates)
    }
    
    func purgeCoordinates() {
        try! localRealm.write {
            localRealm.delete(localRealm.objects(Coordinate.self))
        }
    }
    
    func authUser(login: String, password: String) -> Bool {
        if let user = findUser(byLogin: login),
           user.password == password {
            return true
        }
        return false
    }
    
    func updateOrCreate(user: User) -> UserActionStatus {
        if let oldUser = findUser(byLogin: user.login) {
            try! localRealm.write {
                oldUser.password = user.password
            }
            return .updated
        } else {
            try! localRealm.write {
                localRealm.add(user)
            }
            return .created
        }
    }
    
    func findUser(byLogin: String) -> User? {
        return localRealm.objects(User.self).filter("login = %@", byLogin).first
    }
    
    private init() {}
}
