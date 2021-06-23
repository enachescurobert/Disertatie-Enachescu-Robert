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
    override var annotation: MKAnnotation? {
        willSet {
            if let scooterAnnotation = newValue as? Vehicle {
                if let type = scooterAnnotation.type {
                    switch type {
                    case .scooter:
                        glyphText = "🛴"
                        markerTintColor = .yellow.withAlphaComponent(0.2)
                    case .car:
                        glyphText = "🚗"
                        markerTintColor = .blue.withAlphaComponent(0.2)
                    case .moped:
                        glyphText = "🛵"
                        markerTintColor = .green.withAlphaComponent(0.2)
                    }
                } else {
                    glyphText = "🛸"
                    markerTintColor = .white.withAlphaComponent(0.2)
                }
                if scooterAnnotation.shouldBeOnTopOfCluster {
                    displayPriority = .defaultHigh
                }
                clusteringIdentifier = MKMapViewDefaultClusterAnnotationViewReuseIdentifier
                rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                canShowCallout = true
                let image = UIImage(named: scooterAnnotation.imageName)
                let imageView = UIImageView(image: image)
                detailCalloutAccessoryView = imageView
            }
        }
    }
}
