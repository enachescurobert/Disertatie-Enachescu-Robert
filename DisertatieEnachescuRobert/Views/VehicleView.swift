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
                    case .car:
                        glyphText = "🚗"
                    case .moped:
                        glyphText = "🛵"
                    }
                } else {
                    glyphText = "🛸"
                }
                markerTintColor = UIColor(displayP3Red: 0.082, green: 0.518, blue: 0.263, alpha: 1.0)
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