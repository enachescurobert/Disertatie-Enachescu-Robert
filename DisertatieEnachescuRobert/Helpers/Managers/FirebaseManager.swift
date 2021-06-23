//
//  FirebaseManager.swift
//  DisertatieEnachescuRobert
//
//  Created by Robert Enachescu on 23.06.2021.
//

import Foundation
import Firebase

struct FirebaseManager {
    // Singleton Instance
    private init() {}
    static let shared = FirebaseManager()
    
    func createVehicles() -> [Vehicle] {
        let car1: Car = Car(latitude: 44.48066, longitude: 26.11528, name: "Car 1", shouldBeOnTopOfCluster: false)
        let car2: Car = Car(latitude: 44.47166, longitude: 26.11528, name: "Car 2", shouldBeOnTopOfCluster: true)
        let car3: Car = Car(latitude: 44.45066, longitude: 26.12528, name: "Car 3", shouldBeOnTopOfCluster: false)
        
        let moped1: Moped = Moped(latitude: 44.48266, longitude: 26.11328, name: "Moped 1", shouldBeOnTopOfCluster: false)
        let moped2: Moped = Moped(latitude: 44.47321, longitude: 26.11421, name: "Moped 2", shouldBeOnTopOfCluster: false)
        let moped3: Moped = Moped(latitude: 44.46221, longitude: 26.11521, name: "Moped 3", shouldBeOnTopOfCluster: true)
        let moped4: Moped = Moped(latitude: 44.45843, longitude: 26.11821, name: "Moped 4", shouldBeOnTopOfCluster: false)
        
        let scooter1: Scooter = Scooter(latitude: 44.45333, longitude: 26.11821, name: "Scooter 1", shouldBeOnTopOfCluster: false)
        let scooter2: Scooter = Scooter(latitude: 44.47333, longitude: 26.11921, name: "Scooter 2", shouldBeOnTopOfCluster: true)
        let scooter3: Scooter = Scooter(latitude: 44.46343, longitude: 26.11823, name: "Scooter 3", shouldBeOnTopOfCluster: false)
        
        let cars: [Car] = [car1, car2, car3]
        let mopeds: [Moped] = [moped1, moped2, moped3, moped4]
        let scooters: [Scooter] = [scooter1, scooter2, scooter3]
        
        let vehicles: [Vehicle] = cars + mopeds + scooters
        
        return vehicles
    }

    func fetchVehicles() -> [Vehicle] {
        return createVehicles()
    }
}
