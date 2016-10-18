//
//  MapViewController.swift
//  Prototype
//
//  Created by Kevin Qian on 10/13/16.
//  Copyright © 2016 Kevin Qian. All rights reserved.
//

//import UIKit
//import MapKit
//import CoreLocation
//
//class MapViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate {
//    
//    
//    @IBOutlet weak var o_tf_msgTextField: UITextField!
//    
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        //o_tf_msgTextField.state
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//
//}

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate {
    
    @IBOutlet var map: MKMapView!
    
    @IBOutlet var o_tf_msgTextField: UITextField!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        o_tf_msgTextField.isHidden = true
        
        /* GPS STUFF */
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //accuracy affects battery
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        
        
        
        
        
        
        
        
        /* LONG PRESS */
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.longPressAddContent(gestureRecognizer:)))
        
        uilpgr.minimumPressDuration = 2
        
        map.addGestureRecognizer(uilpgr)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation: CLLocation = locations[0]
        
        setMap(userLocation: userLocation)
        
    }
    
    func setMap(userLocation: CLLocation){
        
        let latDelta: CLLocationDegrees = 0.25 / 69 //each degree is about 69 miles
        
        let lonDelta: CLLocationDegrees = 0.25 / 69 //each degree is about 69 miles
        
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        
        let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        let region: MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
        
        map.setRegion(region, animated: true)
        
    }
    
    func longPressAddContent(gestureRecognizer: UIGestureRecognizer) {
        
        
        let name = textFromTextBox()
        
//        let touchPoint = gestureRecognizer.location(in: self.map)
//        
//        let coordinate = map.convert(touchPoint, toCoordinateFrom: self.map)
//        
//        let annotation = MKPointAnnotation()
//        
//        annotation.coordinate = coordinate
//        
//        annotation.title = name
//        
//        annotation.subtitle = "Maybe I'll go here too.."
//        
//        map.addAnnotation(annotation)

        
    }
    
    func textFromTextBox() -> String {
        
        o_tf_msgTextField.isHidden = false
        
        //var enteredText = ""
        
        let enteredText = o_tf_msgTextField.text!
        
        return enteredText
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {// called when return key pressed
        
        o_tf_msgTextField.isHidden = true
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

