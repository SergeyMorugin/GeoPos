//
//  DBService.swift
//  GeoPos
//
//  Created by Matthew on 05.04.2021.
//  Copyright © 2021 Ostagram Inc. All rights reserved.
//

import Foundation
import RealmSwift

class Coordinate: Object {
    @objc dynamic var latitude: Double = 0
    @objc dynamic var longitude: Double = 0
    
    convenience init(latitude: Double, longitude: Double) {
        self.init()
        self.latitude = latitude
        self.longitude = longitude
    }
}

protocol DBService {
    func save(coordinates: [Coordinate])
    func fetchCoordinates() -> [Coordinate]
    func purgeCoordinates()
}

class RealmService: DBService {
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
            localRealm.deleteAll()
        }
    }
    
    
}
