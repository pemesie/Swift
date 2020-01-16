//
//  CurbsideFinal.swift
//  Speedway Motors iOS Framework
//
//  Created by Derek Vogel on 1/24/19.
//  Copyright © 2019 Derek Vogel. All rights reserved.
//
import Foundation
import UIKit
import SwiftyJSON
import UserNotifications

class CurbsideFinal: UIViewController {
    
    let defaults = UserDefaults.standard
    
    var name = ""
    
    @IBAction func curbside(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    func jsonDetail(){
        var fileNmae = ""
        if(loginConstants.orderVal == 0){
            fileNmae = "order-example"
        }
        else if(loginConstants.orderVal == 1){
            fileNmae = "order-example-2"
        }
        else if(loginConstants.orderVal == 2){
            fileNmae = "order-example-3"
        }
        else if(loginConstants.orderVal == 3){
            fileNmae = "order3"
        }
        else if(loginConstants.orderVal == 4){
            fileNmae = "order4"
        }
        else{
            fileNmae = ""
        }
        let path = Bundle.main.path(forResource: fileNmae, ofType: "json")
        do {
            print("first part\n")
            let data = try Data(contentsOf: URL(fileURLWithPath: path!))
            let json = try JSON(data: data)
            if let title = json["_source"]["order_number"].string{
                name = title
                defaults.set("Shipped", forKey: title)
                // OrderNum.text = name
            }
            
            if let detail = json["_source"]["line_items"][0]["sku_description"].string {
                // OrderName.text = detail
            }
            
            if let cost = json["_source"]["line_items"][0]["post_discount_price"].string{
                print("the cost is ", cost, "\n")
                //OrderCost.text = String(cost)
            }
            
        } catch {
            //  handle error
        }
    }
    
    override func viewDidLoad() {
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "NewWheel"))
        self.navigationItem.titleView?.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        self.navigationItem.titleView?.contentMode = .scaleAspectFit
        self.navigationItem.hidesBackButton = true
        jsonDetail()
        defaults.set("Shipped", forKey: "status")
        
        sendNotification()
    }
    
    // #####  PUSH NOTIFICATION  ####
    // set push notification details
    func sendNotification(){
        let content = UNMutableNotificationContent()
        content.title = "Congratulations"
        content.body = "You Successfully Picked Up an Order"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let request = UNNotificationRequest(identifier: "identifier", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add( request, withCompletionHandler: nil)
        
    }
}
