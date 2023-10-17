//
//  ViewController.swift
//  MapKitExampleApp
//
//  Created by Madhumitha Loganathan on 06/10/23.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {

    private var map : MKMapView = {
        let map = MKMapView()
        return map
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        view.addSubview(map)
        layoutUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        map.frame = view.bounds
    }

    func layoutUI(){
        LocationManager.shared.getUserLocation { [weak self] location in
            DispatchQueue.main.async {
                guard let strongself = self else {
                    return
                }
                strongself.addMapPinTo(location: location)
            }
        }
    }
    
    
    
    
    func addMapPinTo(location: CLLocation){
        let pin  = MKPointAnnotation()
        pin.coordinate  = location.coordinate
        map.setRegion(MKCoordinateRegion(center:location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.7, longitudeDelta: 0.7)), animated: true)
        map.addAnnotation(pin)
        
        LocationManager.shared.resolveLocationNameWith(location: location) { [weak self] locationName in
            self?.title = locationName
        }
    }

}

