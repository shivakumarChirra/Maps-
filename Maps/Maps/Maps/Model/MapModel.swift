//
//  MapModel.swift
//  Maps
//
//  Created by Netaxis on 19/08/25.
//

import CoreLocation
import Foundation

struct Place: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}
