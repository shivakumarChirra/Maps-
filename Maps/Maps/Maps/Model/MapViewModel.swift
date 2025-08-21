//
//  MapViewModel.swift
//  Maps
//
//  Created by Netaxis on 19/08/25.
//

import SwiftUI
import MapKit
import CoreLocation

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: Double.random(in: -85...85),
            longitude: Double.random(in: -180...180)
        ),
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    )
    
    @Published var places: [Place] = []
    @Published var searchQuery = ""
    @Published var selectedPlace: Place?
    @Published var mapType: MKMapType = .standard
    
    private var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func performSearch() {
        let req = MKLocalSearch.Request()
        req.naturalLanguageQuery = searchQuery
        req.region = region
        MKLocalSearch(request: req).start { [weak self] res, _ in
            guard let items = res?.mapItems else { return }
            DispatchQueue.main.async {
                self?.places = items.map {
                    Place(name: $0.name ?? "Unknown", coordinate: $0.placemark.coordinate)
                }
                if let first = self?.places.first {
                    self?.region.center = first.coordinate
                }
            }
        }
    }
    
    func centerOnUser() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
           CLLocationManager.authorizationStatus() == .authorizedAlways,
           let loc = locationManager.location?.coordinate {
            region.center = loc
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    // CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.startUpdatingLocation()
            if let loc = manager.location?.coordinate {
                region.center = loc
            }
        }
    }
}
