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

enum VehicleType: String {
    case car
    case moped
    case scooter
    case unidentified
    
    func getStartOfEnginePrice() -> Double {
        switch self {
        case .car:
            return 5
        case .moped:
            return 3
        case .scooter:
            return 2
        case .unidentified:
            return 0
        }
    }
    
    func getPricePerMinute() -> Double {
        switch self {
        case .car:
            return 2
        case .moped:
            return 1.5
        case .scooter:
            return 1
        case .unidentified:
            return 0
        }
    }
}

class Vehicle: NSObject {
    let id: Int
    let location: CLLocation
    let name: String
    let shouldBeOnTopOfCluster: Bool
    var imageName: String = "ufo.png"
    var type: VehicleType = .unidentified
    
    init(id: Int, latitude: Double, longitude: Double, name: String, shouldBeOnTopOfCluster: Bool) {
        self.id = id
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
