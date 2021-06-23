//
//  MapVC.swift
//  DisertatieEnachescuRobert
//
//  Created by Robert Enachescu on 18/01/2020.
//  Copyright © 2020 Enachescu Robert. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Firebase
import AVFoundation

class MapVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var directionsTableView: UITableView!
    
    // MARK: - Properties
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    var user: User!
    var vehicles: [Vehicle] = []
    var travelDirections: [String] = []
    var polylineDirections: [MKPolyline] = []
    lazy var geocoder = CLGeocoder()
    var voice: AVSpeechSynthesizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        //    MARK: - Setting the map
        let ourLocation = CLLocation(latitude: 44.410, longitude: 26.100)
        let regionRadius: CLLocationDistance = 25000.0
        let region = MKCoordinateRegion(center: ourLocation.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        voice = AVSpeechSynthesizer()
        mapView.setRegion(region, animated: true)
        mapView.delegate = self
        
        //    MARK: - Setting user location
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.requestLocation()
        
        updateUI()
        
        mapView.addAnnotations(vehicles)
        mapView.register(VehicleView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(ClusterView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        
        if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            activateLocationServices()
        } else {
            startLocationService()
        }
        
        directionsTableView.delegate = self
        directionsTableView.dataSource = self
        
        produceOverlay()
    }
    
    //  MARK: - IBActions
    @IBAction func changeMapType(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 || sender.selectedSegmentIndex == 1 {
            mapView.isHidden = false
            directionsTableView.isHidden = true
            if sender.selectedSegmentIndex == 0 {
                mapView.mapType = .standard
                directionsTableView.isHidden = true
            } else if sender.selectedSegmentIndex == 1 {
                mapView.mapType = .satellite
                directionsTableView.isHidden = true
            }
        } else {
            mapView.isHidden = true
            directionsTableView.isHidden = false
        }
    }
    
    private func produceOverlay() {
        var points: [CLLocationCoordinate2D] = []
        points.append(CLLocationCoordinate2DMake(44.5045861, 26.0606003))
        points.append(CLLocationCoordinate2DMake(44.5048310, 26.1622238))
        points.append(CLLocationCoordinate2DMake(44.3830111, 26.1711502))
        points.append(CLLocationCoordinate2DMake(44.3842379, 26.0595703))
        points.append(CLLocationCoordinate2DMake(44.5055655, 26.0595703))
        
        let polygon = MKPolygon(coordinates: &points, count: points.count)
        mapView.addOverlay(polygon)
    }
    
    private func loadDirections(destination:CLLocation?) {
        
        if travelDirections.count != 0 {
            self.travelDirections.removeAll()
            self.directionsTableView.reloadData()
        }
        
        guard let start = currentLocation, let end = destination else { return }
        let request = MKDirections.Request()
        let startMapItem = MKMapItem(placemark: MKPlacemark(coordinate: start.coordinate))
        let endMapItem = MKMapItem(placemark: MKPlacemark(coordinate: end.coordinate))
        request.source = startMapItem
        request.destination = endMapItem
        request.requestsAlternateRoutes = false
        request.transportType = .automobile
        let directions = MKDirections(request: request)
        directions.calculate() {
            [weak self] (response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let route = response?.routes.first {
                
                /// Delete the old polyline if a new one will be created
                let overlays = self!.mapView.overlays
                for overlay in overlays {
                    if overlay is MKPolyline {
                        self!.mapView.removeOverlay(overlay)
                    }
                }
                
                self?.mapView.addOverlay(route.polyline)
                
                let formatter = MKDistanceFormatter()
                formatter.unitStyle = .full
                formatter.units = .metric
                for step in route.steps {
                    let distance = formatter.string(fromDistance: step.distance)
                    self?.travelDirections.append(step.instructions + " (\(distance)")
                }
                self?.directionsTableView.reloadData()
            }
        }
        
    }
    
    @IBAction func signOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.navigationController?.popViewController(animated: true)
        } catch let err {
            print(err)
        }
    }
    
    @IBAction func goToUserLocation(_ sender: Any) {
        mapView.setCenter(mapView?.userLocation.coordinate ?? CLLocationCoordinate2DMake(44.410, 26.100), animated: true)
    }
    
    // MARK: - Methods
    /// We use requestAlwaysAuthorization instead of requestWhenInUseAuthorization
    /// because we need the location of the user even if the app is in background
    private func startLocationService() {
        locationManager?.requestAlwaysAuthorization()
    }
    
    private func activateLocationServices() {
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            for vehicle in vehicles {
                let region = CLCircularRegion(center: vehicle.location.coordinate, radius: 500, identifier: vehicle.name)
                region.notifyOnEntry = true
                locationManager?.startMonitoring(for: region)
            }
        }
        locationManager?.startUpdatingLocation()
    }
    
    private func updateUI() {
        vehicles = FirebaseManager.shared.fetchVehicles()
        printAddress()
    }
    
    private func printAddress() {
        for vehicle in vehicles {
            geocoder.reverseGeocodeLocation(vehicle.location, completionHandler: {
                (placemarks, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                guard let placemark = placemarks?.first else {
                    return
                }
                let streetNumber = placemark.subThoroughfare ?? ""
                if let street = placemark.thoroughfare,
                   let city = placemark.locality,
                   let state = placemark.administrativeArea {
                    print("The address is: \(streetNumber) \(street) \(city), \(state)")
                }
            })
        }
    }
}

//  MARK: - CLLocationManagerDelegate
extension MapVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            activateLocationServices()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if presentingViewController == nil {
            let alertController = UIAlertController(title: "Vehicle nearby", message: "You are near the \(region.identifier). Go ahead, let's drive a little!", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: {
                [weak self] action in
                self?.dismiss(animated: true, completion: nil)
            })
            alertController.addAction(alertAction)
            present(alertController, animated: false, completion: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if currentLocation == nil {
            currentLocation = locations.first
        } else {
            guard let latest = locations.first else {return}
            let distanceInMeters = currentLocation?.distance(from: latest) ?? 0
            print("distance in meters: \(distanceInMeters)")
            currentLocation = latest
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

//  MARK: - MKMapViewDelegate
extension MapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let alert = UIAlertController(title: "Vehicle selected", message: "Do you want a route to this vehicle?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            let destinationLocation = view.annotation?.coordinate
            let destination:CLLocation = CLLocation(latitude: destinationLocation!.latitude, longitude: destinationLocation!.longitude)
            self.loadDirections(destination: destination)
            mapView.deselectAnnotation(view.annotation, animated: false)
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolygon {
            let polyRenderer = MKPolygonRenderer(overlay: overlay)
            polyRenderer.strokeColor = UIColor.green.withAlphaComponent(0.5)
            polyRenderer.fillColor = UIColor.green.withAlphaComponent(0.2)
            polyRenderer.lineWidth = 2.0
            return polyRenderer
        } else if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blue.withAlphaComponent(0.8)
            polylineRenderer.lineWidth = 2.0
            return polylineRenderer
        }
        return MKOverlayRenderer()
    }
}

//  MARK: - UITableViewDelegate
extension MapVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let text = travelDirections[indexPath.row]
        let utterance = AVSpeechUtterance(string: text)
        voice?.speak(utterance)
        
    }
}

//  MARK: - UITableViewDataSource
extension MapVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return travelDirections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DirectionCell", for: indexPath)
        cell.textLabel?.text = travelDirections[indexPath.row]
        return cell
    }
}
