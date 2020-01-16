//
//  FifthViewController.swift
//  Speedway Motors iOS Framework
//
//  Created by Hussain Al Lawati on 10/30/18.
//  Copyright © 2018 Derek Vogel. All rights reserved.
//
import Foundation
import MapKit
import UIKit
import CoreLocation
import GoogleMaps
class ThirdCurbsideView: UIViewController,CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    var locationManager = CLLocationManager()
    //    var mapView: GMSMapView!
    var primaryColor = colorConstants.primaryColor
    var userLat: Double = 0
    var userLong: Double = 0
    var alertDisplayed = false
    let speedwayLocation =  CLLocationCoordinate2D(latitude: locationsConstants.latitude, longitude: locationsConstants.longitude)
    
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    // Screen height.
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    // customize the look of pickup Instructions button
    @IBOutlet weak var pickupInstructions: UIButton!{
        didSet{
            pickupInstructions.layer.borderWidth = 1
            pickupInstructions.layer.borderColor = UIColor.black.cgColor
            pickupInstructions.backgroundColor = primaryColor
            pickupInstructions.setTitleColor(.white, for: .normal)
        }
    }
    
    // customize the look of open maps button
    @IBOutlet weak var OpenMapsButton: UIButton!{
        didSet{
            OpenMapsButton.layer.borderWidth = 1
            OpenMapsButton.layer.borderColor = UIColor.black.cgColor
            OpenMapsButton.backgroundColor = primaryColor
            OpenMapsButton.setTitleColor(.white, for: .normal)
            OpenMapsButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        }
    }
    
    // customize the look of alertforpickup button
    @IBOutlet weak var alertForPickup: UIButton!{
        didSet{
            alertForPickup.layer.borderWidth = 1
            alertForPickup.layer.borderColor = UIColor.black.cgColor
            alertForPickup.backgroundColor = primaryColor
            alertForPickup.setTitleColor(.white, for: .normal)
        }
    }
    
    //open in maps button
    @IBAction func openInMaps(_ sender: Any) {
        // The app open Google Maps to show directions to Speedway Motors as default
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")! as URL)) {
            let url = URL(string:openMapsConstants.googleMapURL)
            UIApplication.shared.open(url!, options: [:])
        } else {
            //if the app couldn't use Google Maps, it will try to open Apple Maps
            print("Can't use comgooglemaps://");
            let appleUrl = URL(string: openMapsConstants.appleMapURL)
            UIApplication.shared.open(appleUrl!, options:[:])
        }
    }
    // actions for when the alertForPickup button is clicked
    @IBAction func alertForPickup(_ sender: Any) {
        let speedway = CLLocation(latitude: locationsConstants.latitude, longitude: locationsConstants.longitude)
        let userLocation = CLLocation(latitude: userLat, longitude: userLong)
        let distance : CLLocationDistance = speedway.distance(from: userLocation)
        print("distance = \(distance) m")
        if(CLLocationManager.authorizationStatus() == .denied){
            //By default, show the action sheet if user denied access to location
            showActionSheet()
        } else if (getDistance()){
            //if user distance is  < 100 m and location allowed
            showActionSheet()
        } else{
            // user distance > 100 m. show alert Not in circle
            print("USER NOT IN RADIUS")
            let alert = UIAlertController(title: "You are not in curbside pickup range", message: "Please get to a curbside pickup parking spot to continue", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    //function to calculate user distance to speedway and return true if < 100m
    func getDistance() -> Bool {
        let speedway = CLLocation(latitude: locationsConstants.latitude, longitude: locationsConstants.longitude)
        let userLocation = CLLocation(latitude: userLat, longitude: userLong)
        let distance : CLLocationDistance = speedway.distance(from: userLocation)
        print("distance = \(distance) m")
        if(distance > 100){
            return false
        }
        return true
    }
    // function to show action sheet that allow user to select which parking spot they are in
    @objc func showActionSheet(){
        // create an alert popup with title and message
        let alert = UIAlertController(title: "Are you ready to Pickup your order and in a Curbside Pickup Parking Spot?", message: "You have to be at a curbside pickup parking spot to continue", preferredStyle: .alert)
        //tint color
        alert.view.tintColor = colorConstants.primaryColor
        // create an option Menu when the user click yes
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            //present the lane in actionSheet style
            let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
            optionMenu.view.tintColor = self.primaryColor
            let lane1 = UIAlertAction(title: "Lane 1", style: .default){action in
                print("Lane1")
                self.performSegue(withIdentifier: "SegToFinal", sender: self)
                
            }
            let lane2 = UIAlertAction(title: "Lane 2", style: .default) {action in
                // let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                // let nextViewController = storyBoard.instantiateViewController(withIdentifier: "fifthView") as! FifthViewController
                //self.present(nextViewController,animated:true, completion:nil)
                self.performSegue(withIdentifier: "SegToFinal", sender: self)
                
            }
            let lane3 = UIAlertAction(title: "Lane 3", style: .default) {action in
                self.performSegue(withIdentifier: "SegToFinal", sender: self)
            }
            let lane4 = UIAlertAction(title: "Lane 4", style: .default){action in
                self.performSegue(withIdentifier: "SegToFinal", sender: self)
            }
            let cancel = UIAlertAction(title: "Cancel", style: .destructive)
            optionMenu.addAction(lane1);
            optionMenu.addAction(lane2);
            optionMenu.addAction(lane3);
            optionMenu.addAction(lane4);
            optionMenu.addAction(cancel);
            self.present(optionMenu, animated: true, completion: nil)
            
        }))
        // when the user click no it would just close the actionsheet
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        //present the actionsheet
        self.present(alert, animated: true)
    }
//    override func viewDidDisappear() {
//        locationManager.stopUpdatingLocation()
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "NewWheel"))
        self.navigationItem.titleView?.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        self.navigationItem.titleView?.contentMode = .scaleAspectFit
        checkLocationService()
        let camera = GMSCameraPosition.camera(withLatitude: locationsConstants.latitude, longitude: locationsConstants.longitude, zoom: 12)
        mapView.camera = camera
        //create speedway marker
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: speedwayLocation.latitude, longitude: speedwayLocation.longitude)
        marker.title = "Speedway Motors"
        marker.snippet="Lincoln"
        marker.map = mapView
        
        // add circle around speedway
        let circle  = GMSCircle(position: speedwayLocation, radius: 100)
        circle.fillColor = UIColor(displayP3Red: 0, green: 0, blue: 1, alpha: 0.1)
        circle.strokeColor = .blue
        circle.strokeWidth = 1
        circle.map = mapView
        
        //start updating user location
        if(CLLocationManager.locationServicesEnabled()){
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = 3
            locationManager.startUpdatingLocation()
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    // check for location update (5m)
    func locationManager(_ manager :CLLocationManager,  didUpdateLocations locations: [CLLocation]){
        let location: CLLocation = locations[locations.count - 1] //  or locations.last!
        if location.horizontalAccuracy > 0 {
            print("--------->>>>>>>Location: \(location)")
            let currentValue:CLLocationCoordinate2D = (locationManager.location?.coordinate)!
            userLat = currentValue.latitude
            userLong = currentValue.longitude
            print("Current User Location: \(userLat)  \(userLong)")
            
        }
        // show the alert for pickup when user entered the circle
        if(alertDisplayed == false && getDistance()){
            alertDisplayed = true
            showActionSheet()
        }
        /* set the has the alert shown up to false, so when user re-entered the circle, the alert will show up again */
        if(!getDistance()){
            alertDisplayed = false
        }
    }
    
    
    func show_marker(position: CLLocationCoordinate2D, mapView: GMSMapView){
        let marker = GMSMarker()
        marker.position = position
        marker.title = "Speedway"
        marker.snippet = "Lincoln,NE"
        marker.map = mapView
    }
    
    //create the circle around speedway on the map
    func show_circle(position: CLLocationCoordinate2D, mapView: GMSMapView){
        let circle  = GMSCircle(position: position, radius: 100)
        circle.fillColor = colorConstants.primaryColor
        circle.strokeColor = colorConstants.primaryColor
        circle.strokeWidth = 1
        circle.map = mapView
    }
    
    // check whether the app has access to user location
    func checkLocationService() {
        // 1. status is not determined
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
            // 2. authorization were denied
        else if CLLocationManager.authorizationStatus() == .denied {
            let locationAlert = UIAlertController(title: "Location services were previously denied. Please enable location services for this app in Settings to have the best experience of curbside pickup", message: "", preferredStyle: .alert)
            
            let settingAction = UIAlertAction(title:"Settings", style: .default) {(_) -> Void in
                let settingURL = URL(string:UIApplication.openSettingsURLString)
                
                if UIApplication.shared.canOpenURL(settingURL!) {
                    UIApplication.shared.open(settingURL!, options:[:])
                }
            }
            locationAlert.addAction(settingAction)
            locationAlert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            locationAlert.view.tintColor = colorConstants.primaryColor
            self.present(locationAlert, animated: true)
        }
    }
}
