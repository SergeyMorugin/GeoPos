//
//  Coordinate.swift
//  GeoPos
//
//  Created by Matthew on 09.04.2021.
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
