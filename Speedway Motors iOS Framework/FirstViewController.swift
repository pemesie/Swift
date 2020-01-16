//
//  FirstViewController.swift
//  Speedway Motors iOS Framework
//
//  Created by Derek Vogel on 10/30/18.
//  Copyright © 2018 Derek Vogel. All rights reserved.
//

import UIKit
import UserNotifications
class FirstViewController: UIViewController, UNUserNotificationCenterDelegate {
    let defaults = UserDefaults.standard

    @IBOutlet weak var streetButton: UIButton!
    
    @IBOutlet weak var imageSlideshow: UIImageView!
    
    var imageSlideArray = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Sign out button on the navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action:#selector(pushLoginScreen))
        navigationItem.rightBarButtonItem?.tintColor = colorConstants.primaryColor
        // set logo style
        let logo = UIImageView(frame:CGRect(x: 0, y: 0, width: 34, height: 34))
        logo.contentMode = .scaleAspectFit
        logo.image = UIImage(named: "NewWheel")
        navigationItem.titleView = logo
        imageSlideArray.append(UIImage(named: "013119_HP.jpg")!)
        imageSlideArray.append(UIImage(named: "012519_HP.jpg")!)
        self.imageSlideshow.animationImages = imageSlideArray
        self.imageSlideshow.animationDuration = 4.0
        self.imageSlideshow.startAnimating()
        self.navigationItem.hidesBackButton = true
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert]){
            (granted,error) in
            if granted{
                print("granted notification")
                self.sendNotification()
            } else{
                print("notfication not granted")
            }
        }
        UNUserNotificationCenter.current().delegate = self
        sendNotification()
    }
    
    
    // #####  PUSH NOTIFICATION  ####
    // set push notification details
    func sendNotification(){
        let content = UNMutableNotificationContent()
        content.title = "Speedway Deals"
        content.body = "Tap Here to Look at New Deals"
        content.sound = UNNotificationSound.default
        let goToWebsite = UNNotificationAction(identifier:"goToWebsite",title:"Get DEALS!",options:[])
        let category = UNNotificationCategory(identifier: "actionCategory",actions: [goToWebsite],intentIdentifiers: [], options: [])
       
        content.categoryIdentifier = "actionCategory"
        UNUserNotificationCenter.current().setNotificationCategories( [category])
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let request = UNNotificationRequest(identifier: "identifier", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add( request, withCompletionHandler: nil)
        
    }
    // #####  PUSH NOTIFICATION  ####
    // display push notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    // handle action on push notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        switch response.actionIdentifier {
        case "goToWebsite":
            openUrl(urlString: "https://www.speedwaymotors.com/deals")
        default:
            break
        }
        completionHandler()
        
        
    }
    
    // singout button actions
    @objc func pushLoginScreen(_ sender: Any){
        //set user default is user logged in to false if they decided to sign out
        let alert = UIAlertController(title: "Confirm Sign Out", message: "Are you sure you would like to sign out?", preferredStyle: .alert)
        //tint color
        alert.view.tintColor = colorConstants.primaryColor
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            //push login view as the rootview
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let loginScreen = storyboard.instantiateViewController(withIdentifier: "FifthViewController")
            let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            appDel.window?.rootViewController = loginScreen
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        //present the actionsheet
        self.present(alert, animated: true)
    }
    
    // change to the next field when the user press next on keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    // connect each button to open their respective link
    
    @IBAction func dealsButton(_ sender: Any) {
        openUrl(urlString: "https://www.speedwaymotors.com/deals")
    }
    @IBAction func streetButton(_ sender: Any) {
        openUrl(urlString: "https://www.speedwaymotors.com/street")
    }
    
    @IBAction func raceButton(_ sender: Any) {
        openUrl(urlString: "https://www.speedwaymotors.com/race")
    }
    
    @IBAction func truckButton(_ sender: Any) {
        openUrl(urlString: "https://www.speedwaymotors.com/truck")
    }
    
    @IBAction func toolboxButton(_ sender: Any) {
        openUrl(urlString: "https://www.speedwaymotors.com/the-toolbox")
    }
    
    @IBAction func giftButton(_ sender: Any) {
        openUrl(urlString: "https://www.speedwaymotors.com/shop/apparel-gifts-and-literature~2-26")
    }

    @IBAction func contactUs(_ sender: Any) {
        openUrl(urlString: "https://www.speedwaymotors.com/Info/AboutUs")
    }
    
    @IBAction func moreButton(_ sender: Any) {
        openUrl(urlString: "https://www.speedwaymotors.com/more")
    }
    
    //open link in safari
    func openUrl(urlString : String!) {
        if let  websiteLink = NSURL(string: urlString) {
            UIApplication.shared.open(websiteLink as URL, options: [:], completionHandler: nil)
        }
    }
}

