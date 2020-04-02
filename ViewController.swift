//
//  ViewController.swift
//  Mapdemo
//
//  Created by Ali Al sharefi on 26/03/2020.
//  Copyright © 2020 Ali Al sharefi. All rights reserved.
//

import UIKit
import MapKit
import FirebaseFirestore

class ViewController: UIViewController {

    @IBOutlet var map: MKMapView!
    @IBOutlet var longPressedLocation: UILongPressGestureRecognizer!

    
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
         //locationManager.delegate = self
         //locationManager.requestWhenInUseAuthorization() // ask user to approve location sharing with the app
         //locationManager.desiredAccuracy = kCLLocationAccuracyKilometer // how precise do you want it?
        // locationManager.startUpdatingLocation() // start getting location data from device in a continuous stream
        
        //How long should the press be?
        longPressedLocation.minimumPressDuration = 0.3
        
         createDemoMarker()// is a marker (red), where the user can click for more info
        
         FirebaseRepo.startListener(vc: self)
        
         //map.showsUserLocation = true
    }
    
    func updateMarkers(snap: QuerySnapshot ) { // now we get the "raw" data from FirebaseRepo
        let markers = MapDataAdapter.getMKAnnotationsFromData(snap: snap) // call adapter to convert data
        map.removeAnnotations(map.annotations) // clear the map
        map.addAnnotations(markers)
    }
    
    @IBAction func longPressed(_ sender: UILongPressGestureRecognizer) {
       /* if sender.state == .ended{ //limit amount of call to just ONE!
            // we don't want to put a marker on the map ourselves, because that will come from Firebase!
            //let cgPoint = sender.location(in: map)
            //now we need to conver x and y to latitude and longitude
            //let coordinate2D = map.convert(cgPoint, toCoordinateFrom: map)
            //print("Long pressed\(coordinate2D)")
            //FirebaseRepo.addMarker(title: "test", lat: coordinate2D.latitude, lon: coordinate2D.longitude)
        }*/
            //Get the location of the longpress
            let touchPoint = longPressedLocation.location(in: self.map)
            let location = self.map.convert(touchPoint, toCoordinateFrom: self.map)
            
            // Start the Alert to get the location name (We are sending location since
            // alerts work async, and we need the title before we create the point)
            showTitleAlert(location: location)
            
            
        
    }
    
    //Show the alert prompt and add the title
    func showTitleAlert(location: CLLocationCoordinate2D){
        var titleTextField: UITextField?
        var alertController: UIAlertController!
        
        //Creating the alertController
        alertController = UIAlertController(title: "Map", message: "Add title for the location", preferredStyle: .alert)
        
        
        //Creates the save button and the marker when pressed
        let locationTitle = UIAlertAction(title: "Save", style: .cancel) { (save) in
            if let title = titleTextField?.text {
                self.createMarker(title: title, lan: location.latitude, lon: location.longitude)
            }
        }
        
        // Create and adds the texfield to the AlertController
        alertController.addTextField { (titleField) in
            titleTextField = titleField
            titleTextField?.placeholder = "Enter title"
        }
        
        // Adds the save button to the AlertController
        alertController.addAction(locationTitle)
        
        // Present the AlertController to the user
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func startUpdate(_ sender: Any) {
        locationManager.startUpdatingLocation()
    }
    
    
    @IBAction func stopUpdate(_ sender: Any) {
        locationManager.stopUpdatingLocation()
    }
    
    fileprivate func createDemoMarker(){
        let marker = MKPointAnnotation() //creates an empty marker
        marker.title = "Go here" //a message on the marker
        let location = CLLocationCoordinate2DMake(55.7, 12.5)
        marker.coordinate = location
        map.addAnnotation(marker)
    }
    
    
    // Function for creating a marker and adding it to the map
    func createMarker(title: String, lan: CLLocationDegrees, lon: CLLocationDegrees){
        let marker = MKPointAnnotation() // Initialize empty marker
        marker.title = title //Text on the marker
        let location = CLLocationCoordinate2DMake(lan, lon)
        marker.coordinate = location
        map.addAnnotation(marker)
    }
    
}

/*
    extension ViewController: CLLocationManagerDelegate{
        func locationmanager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
            if let coord = locations.last?.coordinate{
                print("New location")
                let region = MKCoordinateRegion(center: coord, latitudinalMeters: 300, longitudinalMeters: 300)
                map.setRegion(region, animated: true)
            }
        }
    }
 
 */
    
