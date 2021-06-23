//
//  Scooter.swift
//  DisertatieEnachescuRobert
//
//  Created by Robert Enachescu on 23.06.2021.
//

import Foundation

class Scooter: Vehicle {
    override init(latitude: Double, longitude: Double, name: String, shouldBeOnTopOfCluster: Bool) {
        super.init(latitude: latitude, longitude: longitude, name: name, shouldBeOnTopOfCluster: shouldBeOnTopOfCluster)
        imageName = "scooter.png"
        type = .scooter
    }
}
