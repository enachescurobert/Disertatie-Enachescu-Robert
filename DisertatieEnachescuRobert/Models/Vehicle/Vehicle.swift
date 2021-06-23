//
//  Vehicul.swift
//  DisertatieEnachescuRobert
//
//  Created by Robert Enachescu on 22/01/2020.
//  Copyright © 2020 Enachescu Robert. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

enum VehicleType {
    case car
    case moped
    case scooter
    case unidentified
}

class Vehicle: NSObject {
    let location: CLLocation
    let name: String
    let shouldBeOnTopOfCluster: Bool
    var imageName: String = "ufo.png"
    var type: VehicleType = .unidentified
    
    init(latitude: Double, longitude: Double, name: String, shouldBeOnTopOfCluster: Bool) {
        self.location = CLLocation(latitude: latitude, longitude: longitude)
        self.name = name
        self.shouldBeOnTopOfCluster = shouldBeOnTopOfCluster
    }
}

extension Vehicle: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        get {
            return location.coordinate
        }
    }
    
    var title: String? {
        get {
            return name
        }
    }
}
