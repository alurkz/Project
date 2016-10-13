//
//  ViewController.swift
//  Map Test
//
//  Created by Alex Albanna on 10/13/16.
//  Copyright © 2016 Alex Albanna. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate {
    
    @IBOutlet var map: MKMapView!
    @IBOutlet var textBox: UITextField!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        textBox.isHidden = true
        
        /* GPS STUFF */
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //accuracy affects battery
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        
        
        
        
        
        
        
        
        /* LONG PRESS */
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.longpress(gestureRecognizer:)))
        
        uilpgr.minimumPressDuration = 2
        
        map.addGestureRecognizer(uilpgr)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation: CLLocation = locations[0]
        
        setMap(userLocation: userLocation)
        
    }
    
    func setMap(userLocation: CLLocation){
        
        let latDelta: CLLocationDegrees = 0.05
        
        let lonDelta: CLLocationDegrees = 0.05
        
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        
        let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        let region: MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
        
        map.setRegion(region, animated: true)
        
    }
    
    func longpress(gestureRecognizer: UIGestureRecognizer) {
        
        textBox.isHidden = false
        
        let name = textBox.text
        
        print(name)
        
        let touchPoint = gestureRecognizer.location(in: self.map)

        let coordinate = map.convert(touchPoint, toCoordinateFrom: self.map)
        
        let annotation = MKPointAnnotation()

        annotation.coordinate = coordinate
        
        annotation.title = name
        
        annotation.subtitle = "Maybe I'll go here too.."
        
        map.addAnnotation(annotation)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

