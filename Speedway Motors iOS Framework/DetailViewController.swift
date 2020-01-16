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
class DetailViewController: UIViewController {
    var name = ""
    @IBOutlet var OrderNum: UILabel!
    
    
    
    func jsonDetail(){
        let fileNmae = "order-example"
        let path = Bundle.main.path(forResource: fileNmae, ofType: "json")
        do {
            print("first part\n")
            let data = try Data(contentsOf: URL(fileURLWithPath: path!))
            let json = try JSON(data: data)
            if let title = json["_source"]["order_number"].string{
                name = title
                OrderNum.text = "wow"
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


