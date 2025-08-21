//
//  UIKitGlobeMapView.swift
//  Maps
//
//  Created by Netaxis on 19/08/25.
//



import MapKit
import SwiftUI
import MapKit

struct UIKitGlobeMapView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    var places: [Place]
    var mapType: MKMapType
    var onSelectPlace: (Place) -> Void
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.showsTraffic = true
        mapView.showsCompass = true
        mapView.mapType = mapType
        
        let cam = MKMapCamera(lookingAtCenter: region.center, fromDistance: 1_000_000, pitch: 70, heading: 0)
        mapView.setCamera(cam, animated: false)
        mapView.setRegion(region, animated: false)
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.mapType = mapType
        let cam = MKMapCamera(lookingAtCenter: region.center, fromDistance: 1_000_000, pitch: 70, heading: 0)
        uiView.setCamera(cam, animated: true)
        
        uiView.removeAnnotations(uiView.annotations)
        let annos = places.map { place in
            let a = MKPointAnnotation()
            a.coordinate = place.coordinate
            a.title = place.name
            return a
        }
        uiView.addAnnotations(annos)
    }
    
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: UIKitGlobeMapView
        init(_ parent: UIKitGlobeMapView) { self.parent = parent }
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            guard let ann = view.annotation else { return }
            if let p = parent.places.first(where: {
                abs($0.coordinate.latitude - ann.coordinate.latitude) < 0.0001 &&
                abs($0.coordinate.longitude - ann.coordinate.longitude) < 0.0001
            }) {
                parent.onSelectPlace(p)
            }
        }
    }
}
