//
//  FirebaseManager.swift
//  DisertatieEnachescuRobert
//
//  Created by Robert Enachescu on 23.06.2021.
//

import Foundation
import Firebase
import UIKit

struct FirebaseManager {
    // Singleton Instance
    private init() {}
    static let shared = FirebaseManager()
    
    func createVehicles() -> [Vehicle] {
        let car1: Car = Car(id: 1, latitude: 44.48066, longitude: 26.11528, name: "Car 1", shouldBeOnTopOfCluster: false)
        let car2: Car = Car(id: 2, latitude: 44.47166, longitude: 26.11528, name: "Car 2", shouldBeOnTopOfCluster: true)
        let car3: Car = Car(id: 3, latitude: 44.45066, longitude: 26.12528, name: "Car 3", shouldBeOnTopOfCluster: false)
        
        let moped1: Moped = Moped(id: 4, latitude: 44.48266, longitude: 26.11328, name: "Moped 1", shouldBeOnTopOfCluster: false)
        let moped2: Moped = Moped(id: 5, latitude: 44.47321, longitude: 26.11421, name: "Moped 2", shouldBeOnTopOfCluster: false)
        let moped3: Moped = Moped(id: 6, latitude: 44.46221, longitude: 26.11521, name: "Moped 3", shouldBeOnTopOfCluster: true)
        let moped4: Moped = Moped(id: 7, latitude: 44.45843, longitude: 26.11821, name: "Moped 4", shouldBeOnTopOfCluster: false)
        
        let scooter1: Scooter = Scooter(id: 8, latitude: 44.45333, longitude: 26.11821, name: "Scooter 1", shouldBeOnTopOfCluster: false)
        let scooter2: Scooter = Scooter(id: 9, latitude: 44.44333, longitude: 26.11321, name: "Scooter 2", shouldBeOnTopOfCluster: true)
        let scooter3: Scooter = Scooter(id: 10, latitude: 44.46343, longitude: 26.11823, name: "Scooter 3", shouldBeOnTopOfCluster: false)
        
        let ufo1: Vehicle = Vehicle(id: 1996, latitude: 44.45343, longitude: 26.12323, name: "OZN 1", shouldBeOnTopOfCluster: false)
        
        let cars: [Car] = [car1, car2, car3]
        let mopeds: [Moped] = [moped1, moped2, moped3, moped4]
        let scooters: [Scooter] = [scooter1, scooter2, scooter3]
        let ufos: [Vehicle] = [ufo1]
        
        let vehicles: [Vehicle] = cars + mopeds + scooters + ufos
        
        return vehicles
    }

    func fetchVehicles() -> [Vehicle] {
        return createVehicles()
    }
    
    func saveTrip(of user: User, vehicleType: VehicleType, totalPrice: Double, totalTimeSpent: String, vc: UIViewController) {
        let database = Database.database(url: "https://disertatieenachescurobert-default-rtdb.europe-west1.firebasedatabase.app")
        let usersRef = database.reference(withPath: "users")
        let userRef = usersRef.child(user.uid)
        let tripsRef = userRef.child("trips")
        let currentTrip = tripsRef.childByAutoId()
        
        let values: [String:Any] = [
            "userEmail": user.email,
            "userUid": user.uid,
            "vehicle": vehicleType.rawValue,
            "totalPrice": "\(totalPrice)$",
            "totalTimeSpent": totalTimeSpent
        ]
        currentTrip.setValue(values) { error, databaseReference in
            guard let error = error else {
                return
            }
            AlertManager.shared.showAlertMessage(vc: vc, message: error.localizedDescription, handler: {})
        }
    }
}
