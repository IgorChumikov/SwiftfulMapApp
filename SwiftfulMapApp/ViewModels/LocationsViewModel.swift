//
//  LocationsViewModel.swift
//  SwiftfulMapApp
//
//  Created by Игорь Чумиков on 15.07.2023.
//

import SwiftUI
import MapKit

final class LocationsViewModel: ObservableObject {
    
    @Published var locations: [Location]
    @Published var mapLocation: Location {
        didSet {
            upDateMapRegion(location: mapLocation)
        }
    }
    @Published var mapRegion: MKCoordinateRegion = .init()
    
    // Current region on map
    private var mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    
    // Show list of location
    @Published var showLocationsList: Bool = false
    
    init() {
        let locations = LocationsDataService.locations
        self.locations = locations
        self.mapLocation = locations.first!
        
        self.upDateMapRegion(location: locations.first!)
    }
    
    func toggleLocationsList() {
        withAnimation(.easeInOut) {
            showLocationsList.toggle()
        }
    }

    func showNextLocation(location: Location) {
        withAnimation(.easeInOut) {
           mapLocation = location
           showLocationsList = false
        }
    }
    
    func nextButtonPessed() {
        guard let currentIndex = locations.firstIndex(where: { $0 == mapLocation }) else { return }
        
        let nextIndex = currentIndex + 1
        guard locations.indices.contains(nextIndex) else {
            guard let firsLocation = locations.first else { return }
            showNextLocation(location: firsLocation)
            return
        }
        
        let nextLocation = locations[nextIndex]
        showNextLocation(location: nextLocation)
    }
    
    private func upDateMapRegion(location: Location) {
        withAnimation(.easeInOut) {
            mapRegion = MKCoordinateRegion(
                center: location.coordinates,
                span: mapSpan
            )
        }
    }
}
