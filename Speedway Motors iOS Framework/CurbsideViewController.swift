//
//  CurbsideViewController.swift
//  Speedway Motors iOS Framework
//
//  Created by Josiah Ngu on 3/31/19.
//  Copyright © 2019 Derek Vogel. All rights reserved.
//

import UIKit

class CurbsideViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // centered logo on the navigation bar
            self.navigationItem.titleView = UIImageView(image: UIImage(named: "NewWheel"))
            self.navigationItem.titleView?.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
            self.navigationItem.titleView?.contentMode = .scaleAspectFit
    }
    

}
