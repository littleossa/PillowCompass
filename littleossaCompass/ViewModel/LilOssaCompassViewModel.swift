//
//  LilOssaCompassViewModel.swift
//  littleossaCompass
//
//

import SwiftUI
import CoreLocation

class LilOssaCompassViewModel: NSObject, ObservableObject {
    
    @Published var pillowDegrees: Double?
    
    private let locationManager = CLLocationManager()
    private let lilossaCoordinateAPI = LiLossaCoordinateAPI()
    
    private var currentLilossaCoordinate: CLLocationCoordinate2D?
    private var currentOwnerCoordinate: CLLocationCoordinate2D?
    
    func setup() async {
        await fetchCurrentLilossaCoordinate()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func calculatePillowDegreesWithLatestLilOssaCoordinate() async {
        await fetchCurrentLilossaCoordinate()
        await calculatePillowDegreesFromCurrentCoordinates()
    }
    
    private func fetchCurrentLilossaCoordinate() async {
        do {
            guard let coordinate = try await lilossaCoordinateAPI.fetchLatestCoordinate()
            else { return }
            currentLilossaCoordinate = CLLocationCoordinate2D(latitude: coordinate.latitude,
                                                              longitude: coordinate.longitude)
        } catch {
            // Some Error Handling
        }
    }
    
    @MainActor
    private func calculatePillowDegreesFromCurrentCoordinates() {
        guard let currentOwnerCoordinate,
              let currentLilossaCoordinate else { return }
        
        withAnimation {
            pillowDegrees = calculatePillowDegreesFrom(currentCoordinate: currentOwnerCoordinate,
                                                       targetCoordinate: currentLilossaCoordinate)
        }
    }
    
    private func calculatePillowDegreesFrom(currentCoordinate: CLLocationCoordinate2D,
                                    targetCoordinate: CLLocationCoordinate2D) -> Double {
        
        let currentLatitudeRadian = currentCoordinate.latitude.radian
        let currentLongitudeRadian = currentCoordinate.longitude.radian
        let targetLatitudeRadian = targetCoordinate.latitude.radian
        let targetLongitudeRadian = targetCoordinate.longitude.radian
        
        let longitudeRadianDifference = targetLongitudeRadian - currentLongitudeRadian
        let y = sin(longitudeRadianDifference)
        let x = cos(currentLatitudeRadian) * tan(targetLatitudeRadian) - sin(currentLatitudeRadian) * cos(longitudeRadianDifference)
        let p = atan2(y, x) * 180 / CGFloat.pi
        
        if p < 0 {
            return 360 + atan2(y, x) * 180 / CGFloat.pi
        }
        
        return atan2(y, x) * 180 / CGFloat.pi
    }
}

// MARK: - CLLocation Manager
extension LilOssaCompassViewModel: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let currentLocation = locations.last else { return }
        currentOwnerCoordinate = currentLocation.coordinate
        
        Task { @MainActor in
            calculatePillowDegreesFromCurrentCoordinates()
        }
    }
}
