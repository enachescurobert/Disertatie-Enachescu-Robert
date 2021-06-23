//
//  Car.swift
//  DisertatieEnachescuRobert
//
//  Created by Robert Enachescu on 23.06.2021.
//

import Foundation

class Car: Vehicle {
    override init(id: Int, latitude: Double, longitude: Double, name: String, shouldBeOnTopOfCluster: Bool) {
        super.init(id: id, latitude: latitude, longitude: longitude, name: name, shouldBeOnTopOfCluster: shouldBeOnTopOfCluster)
        imageName = "car.png"
        type = .car
    }
}
