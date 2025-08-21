//
//  ContentView.swift
//  Maps
//
//  Created by Netaxis on 19/08/25.


import SwiftUI
import MapKit
import CoreLocation


struct MainView: View {
    @StateObject private var viewModel = MapViewModel()
    
    var body: some View {

        ZStack {
            UIKitGlobeMapView(region: $viewModel.region, places: viewModel.places, mapType: viewModel.mapType) { place in
                viewModel.selectedPlace = place
            }
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    TextField("Search...", text: $viewModel.searchQuery)
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .cornerRadius(8)
                    Button("Search") { viewModel.performSearch() }
                }
                .padding()
                
                HStack(spacing: 8) {
                    Button("Standard") { viewModel.mapType = .standard }
                    Button("Satellite") { viewModel.mapType = .satellite }
                    Button("Hybrid") { viewModel.mapType = .hybrid }
                }
                .buttonStyle(.bordered)
                .padding(.horizontal)
                
                HStack(spacing: 8) {
                    Button(action: {
                        let newLatDelta = max(viewModel.region.span.latitudeDelta / 2, 0.0001)
                        let newLonDelta = max(viewModel.region.span.longitudeDelta / 2, 0.0001)
                        viewModel.region.span = MKCoordinateSpan(latitudeDelta: newLatDelta, longitudeDelta: newLonDelta)
                    }) {
                        Image(systemName: "plus.magnifyingglass")
                            .font(.title2)
                            .padding(8)
                            .background(.ultraThinMaterial)
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        let newLatDelta = min(viewModel.region.span.latitudeDelta * 2, 180)
                        let newLonDelta = min(viewModel.region.span.longitudeDelta * 2, 360)
                        viewModel.region.span = MKCoordinateSpan(latitudeDelta: newLatDelta, longitudeDelta: newLonDelta)
                    }) {
                        Image(systemName: "minus.magnifyingglass")
                            .font(.title2)
                            .padding(8)
                            .background(.ultraThinMaterial)
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                HStack {
                    Spacer()
                    Button(action: viewModel.centerOnUser) {
                        Image(systemName: "location.fill")
                            .font(.title2)
                            .padding(12)
                            .background(Color.white.opacity(0.8))
                            .clipShape(Circle())
                    }
                    .padding()
                }
            }
        }
        .sheet(item: $viewModel.selectedPlace) { place in
            VStack {
                Text(place.name)
                    .font(.largeTitle)
                    .padding()
                Spacer()
            }
        }
    }
}

