//
//  VehicleView.swift
//  DisertatieEnachescuRobert
//
//  Created by Robert Enachescu on 31/01/2020.
//  Copyright © 2020 Enachescu Robert. All rights reserved.
//

import UIKit
import MapKit

class VehicleView: MKMarkerAnnotationView {
    
    var vehicle: Vehicle?
    
    override var annotation: MKAnnotation? {
        willSet {
            if let vehicleAnnotation = newValue as? Vehicle {
                
                self.vehicle = vehicleAnnotation
                
                switch vehicleAnnotation.type {
                case .scooter:
                    glyphText = "🛴"
                    markerTintColor = .yellow.withAlphaComponent(0.2)
                case .car:
                    glyphText = "🚗"
                    markerTintColor = .blue.withAlphaComponent(0.2)
                case .moped:
                    glyphText = "🛵"
                    markerTintColor = .green.withAlphaComponent(0.2)
                default:
                    glyphText = "🛸"
                    markerTintColor = .white.withAlphaComponent(0.2)
                }
                
                if vehicleAnnotation.shouldBeOnTopOfCluster {
                    displayPriority = .defaultHigh
                }
                clusteringIdentifier = MKMapViewDefaultClusterAnnotationViewReuseIdentifier
                rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                canShowCallout = true
                guard let image = UIImage(named: vehicleAnnotation.imageName) else {
                    return
                }
                let imageView = UIImageView(image: image.resized(to: CGSize(width: 50, height: 50)))
                detailCalloutAccessoryView = imageView
            }
        }
    }
}
