
//
//  DetailViewController.swift
//  Speedway Motors iOS Framework
//
//  Created by Derek Vogel on 1/24/19.
//  Copyright © 2019 Derek Vogel. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
class OrderHistoryDetail: UIViewController {
    var name = ""
    
    @IBOutlet var HistoryNo: UILabel!
    
    @IBOutlet var ItemsHistory: UILabel!
    @IBOutlet var OrderHistory: UILabel!
    @IBOutlet var OrderDate: UILabel!
    @IBOutlet var SKUNumber: UILabel!
    
    
    @IBOutlet var CostHistory: UILabel!
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
        let path = Bundle.main.path(forResource: fileNmae, ofType: "json")
        do {
            print("first part\n")
            let data = try Data(contentsOf: URL(fileURLWithPath: path!))
            let json = try JSON(data: data)
            if let title = json["_source"]["order_number"].string{
                name = title
                HistoryNo.text = name
                if defaults.string(forKey: title) != nil{
                    OrderHistory.text = defaults.string(forKey: title)
                }
                else{
                    if let status1 = json["_source"]["line_items"][0]["item_status"].string{
                        OrderHistory.text = status1
                    }
                }
                
                
            }
            
            if let detail = json["_source"]["line_items"][0]["sku_description"].string {
                ItemsHistory.text = detail
            }
            
            if let cost = json["_source"]["order_total"].double{
                print("the cost is ", cost, "\n")
                CostHistory.text = ("$" + String(cost))
            }
            if let itemNum = json["_source"]["line_items"][0]["sku_number"].string {
                SKUNumber.text = itemNum
            }
            if let date = json["_source"]["order_date"].string{
                OrderDate.text = date
            }
            
            
            
            
        } catch {
            //  handle error
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "NewWheel"))
        self.navigationItem.titleView?.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        self.navigationItem.titleView?.contentMode = .scaleAspectFit
        jsonDetail()
    }
    
}



