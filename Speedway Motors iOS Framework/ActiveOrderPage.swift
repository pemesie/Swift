//
//  FifthViewController.swift
//  Speedway Motors iOS Framework
//
//  Created by Hussain Al Lawati on 10/30/18.
//  Copyright © 2018 Derek Vogel. All rights reserved.
//

import Foundation

import UIKit
import SwiftyJSON

/*struct cellData {
 var opened = Bool()
 var title = String()
 var sectionData = [String]()
 }
 */

var orders: [String] = []
let defaults = UserDefaults.standard

func jsonint(){
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
    if(loginConstants.orderVal == 5){
        fileNmae = ""
        orders = []
    }
        
    else{
        let path = Bundle.main.path(forResource: fileNmae, ofType: "json")
        do {
            print("first part\n")
            let data = try Data(contentsOf: URL(fileURLWithPath: path!))
            let json = try JSON(data: data)


            if let title = json["_source"]["order_number"].string{

                if defaults.string(forKey: title) == "Shipped"{
                    
                    print("the order should not show up")
                    orders = []
                }
                else{
                    if let stat = json["_source"]["line_items"][0]["item_status"].string{
                        defaults.set(stat, forKey: title)
                        orders = [title]
                    }
                }
                print("the status is", defaults.string(forKey: title ?? "nil")!)
                
            }
            
            
        } catch {
            
            // handle error
        }
    }
}


class ActiveOrderPage: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var Labl: UILabel!
    
    @IBOutlet var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        loadData()
        table.reloadData()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "NewWheel"))
        self.navigationItem.titleView?.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        self.navigationItem.titleView?.contentMode = .scaleAspectFit
        jsonint()
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = orders[indexPath.item]
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        //I'm trying to pass the data to the next view, but it keeps crashing
        //let o = orders[indexPath.row]
        //  let story = UIStoryboard(name: <#T##String#>, bundle: <#T##Bundle?#>)
        performSegue(withIdentifier: "Seg", sender: cell)
    }
    
    
    func loadData(){
        table.reloadData()
        
    }
    
    
    
    
    
}
