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
import Parse

class MapViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate {
    
    
    private func mapView(mapView: MKMapView!,
                 viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)! as MKAnnotationView
        if pinView == nil {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView.canShowCallout = true
            pinView.image = UIImage(named:"map_send.png")!
            
        }
        else {
            pinView.annotation = annotation
        }
        
        return pinView
    }
    
    
    @IBOutlet var map: MKMapView!
    
    @IBOutlet var o_tf_msgTextField: UITextField!
    
    var userLocation: CLLocation!

    
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
        if !((o_tf_msgTextField.text?.isEmpty)!) {
            sendMessage()
            o_tf_msgTextField.text = ""
        }
    }
    
    
    func addToMap(object: PFObject) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: object["Latitude"] as! CLLocationDegrees, longitude: object["Longitude"] as! CLLocationDegrees)
        annotation.title = object["Message"] as! String
        
        map.addAnnotation(annotation)
    }
    
    func refreshMessages(){
        var receivedMessages = [PFObject]()
        let query = PFQuery(className: "Messages")
        query.findObjectsInBackground { (objects, error) -> Void in
            if objects != nil {
                
                for object in objects! as [PFObject] {
                    
                    if self.userLocation.distance(from: CLLocation(latitude: object["Latitude"] as! CLLocationDegrees, longitude: object["Longitude"] as! CLLocationDegrees)) <= 10.0  {
                        
                        receivedMessages.append(object)
                        self.addToMap(object: object)
                    }
                    
                }
                
                
            } else {
                
                if error != nil {
                    
                    print (error)
                    
                } else {
                    
                    print ("Error!")
                    
                }
            }
        }
        
        //return receivedMessages
    }
    
    func sendMessage() {
        let newMessage = PFObject(className: "Messages")
        newMessage["Message"] = o_tf_msgTextField.text!
        newMessage["Latitude"] = userLocation.coordinate.latitude
        newMessage["Longitude"] = userLocation.coordinate.longitude
        newMessage.saveInBackground { (success, error) -> Void in
            if success {
                
                print("Object has been saved.")
                
            } else {
                
                if error != nil {
                    
                    print (error)
                    
                } else {
                    
                    print ("Error")
                }
                
            }
        }
        //addToMap();
        refreshMessages()
        o_tf_msgTextField.text = "";
        /*if TestMessages.count > 0 {
         o_tf_msgTextField.text = TestMessages[0]["Message"] as! String + " Received!"
         }*/
    }
    
    
    var refreshTimer : Timer = Timer();
    
    
    /////////////////////////////////
    //Region: Location Services
    /////////////////////////////////
    var locationManager = CLLocationManager()
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        userLocation = locations[0]
        
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
    
    /*
    func addToMap() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = userLocation.coordinate
        annotation.title = o_tf_msgTextField.text!
        
        o_tf_msgTextField.text = "";
        map.addAnnotation(annotation)
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
    
    
    func setupNotificationSettings() {
        let notificationSettings: UIUserNotificationSettings! = UIApplication.shared.currentUserNotificationSettings
        
        if (notificationSettings.types == []){
            // Specify the notification types.
            let notificationTypes: UIUserNotificationType = [.alert, .sound, .badge];
            
            // Specify the notification actions.
            let notification = UIMutableUserNotificationAction()
            notification.identifier = "notify"
            notification.title = "New Message"
            notification.activationMode = UIUserNotificationActivationMode.background
            notification.isDestructive = true
            notification.isAuthenticationRequired = false
            
            let actionsArray = NSArray(objects: notification)
            //let actionsArrayMinimal = NSArray(objects: trashAction, modifyListAction)
            
            // Specify the category related to the above actions.
            let notificationCategory = UIMutableUserNotificationCategory()
            notificationCategory.identifier = "notifyCategory"
            notificationCategory.setActions(actionsArray as? [UIUserNotificationAction], for: UIUserNotificationActionContext.default)
            
            let categoriesForSettings = NSSet(objects: notificationCategory)
            
            // Register the notification settings.
            let newNotificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: categoriesForSettings as? Set<UIUserNotificationCategory>)
            UIApplication.shared.registerUserNotificationSettings(newNotificationSettings)
        }
    }
    
    func scheduleLocal() {
        let notification = UILocalNotification()
        notification.fireDate = Date(timeIntervalSinceNow: -25199)
        notification.alertBody = "Hey you! Yeah you! Swipe to unlock!"
        notification.alertAction = "be awesome!"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["CustomField1": "w00t"]
        UIApplication.shared.scheduleLocalNotification(notification)
        
        /*
        guard let settings = UIApplication.shared.currentUserNotificationSettings else { return }
        
        if settings.types == .none {
            let ac = UIAlertController(title: "Can't schedule", message: "Either we don't have permission to schedule notifications, or we haven't asked yet.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
            return
        }
 */
    }
    
    
    var notifyTimer: Timer = Timer();
    override func viewDidAppear(_ animated: Bool) {
        init_textfield()
        
        NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //o_tf_msgTextField.isHidden = true
        
        /* GPS STUFF */
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        setupNotificationSettings();
        notifyTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(scheduleLocal), userInfo: nil, repeats: true)
        
        refreshTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(refreshMessages), userInfo: nil, repeats: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

