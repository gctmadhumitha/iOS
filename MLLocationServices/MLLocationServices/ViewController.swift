//
//  ViewController.swift
//  Trial
//
//  Created by Loganathan, Madhumitha on 4/5/17.
//  Copyright © 2017 Intuit. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var locationTable: UITableView!
    var locationManager:CLLocationManager!
    var timer : Timer?
    
    var locations: [CLLocation] = []
    
    @IBOutlet var startButton: UIButton!
    @IBOutlet var stopButton: UIButton!
    @IBOutlet var locationText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationTable.delegate = self
        locationTable.dataSource = self
        stopButton.isEnabled = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func OnStart(_ sender: AnyObject) {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
            timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.updateTable), userInfo: nil, repeats: true)
             stopButton.isEnabled = true
             startButton.isEnabled = false
            
        }
    }
    
    func updateTable(){
        locationTable.reloadData()
    }
    
    @IBAction func onStop(_ sender: AnyObject) {
        locationManager.stopUpdatingLocation()
        timer?.invalidate()
        stopButton.isEnabled = false
        startButton.isEnabled = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let currentLocation = locations[0]
            self.locations.append(currentLocation)
            locationText.textColor = UIColor.black
            locationText.text = "\(currentLocation.coordinate.latitude), \(currentLocation.coordinate.longitude)"
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationText.text = "Error occured"
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell!

        if cell == nil{
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        }
        
        let cellLocation = locations[indexPath.row]
        cell?.textLabel?.textColor = UIColor.black
        cell?.textLabel?.text = "\(cellLocation.coordinate.latitude), \(cellLocation.coordinate.longitude)"
        return cell!
        
    }
}

