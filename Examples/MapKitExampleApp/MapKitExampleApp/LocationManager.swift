//
//  LocationManager.swift
//  MapKitExampleApp
//
//  Created by Madhumitha Loganathan on 06/10/23.
//

import CoreLocation
import Foundation


class LocationManager : NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    var completion: ((CLLocation)-> Void)?
    let manager = CLLocationManager()
    
    func getUserLocation(completion: @escaping ((CLLocation) -> Void)) {
        self.completion  = completion
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        completion?(location)
        manager.stopUpdatingLocation()
    }
    
    func resolveLocationNameWith(location:CLLocation, completion: @escaping ((String?)-> Void)) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard let place = placemarks?.first, error == nil else {
                completion(nil)
                return
            }
            print(place)
            var name = ""
            if let locality = place.locality {
                name += locality
            }
            if let adminRegion = place.administrativeArea {
                name += ", \(adminRegion)"
            }
            completion(name)
        }
    }
}
