//
//  MapViewController.swift
//  Prototype
//
//  Created by Kevin Qian on 10/13/16.
//  Copyright © 2016 Kevin Qian. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate {
    
    @IBOutlet var map: MKMapView!
    
    @IBOutlet var o_tf_msgTextField: UITextField!

    
    /////////////////////////////////
    //Region: Text field/Send Management
    /////////////////////////////////
    func init_textfield() {
        o_tf_msgTextField.frame = CGRect(x: 64, y: 552, width: 0, height: 30)
        setTextfieldHidden()
        o_bt_popTextField.setNeedsDisplay()
        
        o_bt_send.alpha = 0
        o_bt_send.isEnabled = false
    }
    
    var tf_timer: Timer = Timer()
    func setTextfieldActive() {
        o_tf_msgTextField.isHidden = false
        tf_state = .shown
    }
    func setTextfieldHidden() {
        o_tf_msgTextField.isHidden = true
        tf_state = .hidden
    }
    enum textFieldStates {
        case shown
        case hidden
        case none
    }
    //var isTextFieldShown = false;
    var tf_state: textFieldStates = .hidden
    @IBOutlet var o_bt_popTextField: UIButton!
    @IBOutlet var o_bt_send: UIButton!
    
    //Pop text field and rotate the button
    @IBAction func a_bt_popTextField(_ sender: AnyObject) {
        if isKeyboardShown == true {
            //FIXME: better animation
            return
        }
        
        
        if tf_state == .hidden {
            tf_timer.invalidate()
            tf_state = .none //avoid action collisions
            setTextfieldActive()
            UIView.animate(withDuration: 0.7, animations: {
                self.o_tf_msgTextField.frame = CGRect(x: 81, y: 552, width: 213, height: 30)
                self.o_bt_popTextField.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
                self.o_bt_send.alpha = 1
            })
            o_bt_send.isEnabled = true
            //isTextFieldShown = true
        } else if tf_state == .shown {
            tf_timer.invalidate()
            tf_state = .none //avoid action collisions
            tf_timer = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(MapViewController.setTextfieldHidden), userInfo: nil, repeats: false)
            
            UIView.animate(withDuration: 0.7, animations: {
                self.o_tf_msgTextField.frame = CGRect(x: 64, y: 552, width: 0, height: 30)
                self.o_bt_popTextField.transform = CGAffineTransform(rotationAngle: CGFloat(0))
                
                self.o_bt_send.alpha = 0
            })
            o_bt_send.isEnabled = false
            //isTextFieldShown = false
        }
    }
    //send button
    @IBAction func a_bt_send(_ sender: AnyObject) {
        sendMessage()
        
        o_tf_msgTextField.text = ""
    }
    
    //TODO: Implement this
    func sendMessage() {
        
    }
    
    
    /////////////////////////////////
    //Region: Location Services
    /////////////////////////////////
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //o_tf_msgTextField.isHidden = true
        
        /* GPS STUFF */
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
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
        
        
        //let name = textFromTextBox()
        
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
    
    /*
    func textFromTextBox() -> String {
        
        o_tf_msgTextField.isHidden = false
        
        //var enteredText = ""
        
        let enteredText = o_tf_msgTextField.text!
        
        return enteredText
        
    }
     */
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endTextfieldEditing()
        //self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {// called when return key pressed
        
        textField.resignFirstResponder()
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.o_tf_msgTextField.frame = CGRect(x: 81, y: 552, width: 213, height: 30)
        })
        
        return true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        init_textfield()
        
        NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var isKeyboardShown = false
    
    func keyboardWillShow(notification: NSNotification) {
        isKeyboardShown = true
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame: NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        setEditPosition(keyboardHeight: keyboardHeight)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        isKeyboardShown = false
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame: NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        setEditPosition(keyboardHeight: keyboardHeight)
    }
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    func setEditPosition(keyboardHeight: CGFloat) {
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.o_tf_msgTextField.frame = CGRect(x: 81, y:
                self.screenSize.height - keyboardHeight - 40, width: 213, height: 30)
            self.o_bt_popTextField.frame = CGRect(x: 17, y:  self.screenSize.height - keyboardHeight - 49, width: 50, height: 50)
            self.o_bt_send.frame = CGRect(x: 310, y: self.screenSize.height - keyboardHeight - 41, width: 35, height: 35)
        })
    }
    
    func endTextfieldEditing() {
        self.view.endEditing(true)
        if tf_state == .shown {
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.o_tf_msgTextField.frame = CGRect(x: 81, y: 552, width: 213, height: 30)
                self.o_bt_popTextField.frame = CGRect(x: 17, y: 543, width: 50, height: 50)
                self.o_bt_send.frame = CGRect(x: 310, y: 551, width: 35, height: 35)
            })
        }
    }

}

