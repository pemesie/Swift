//
//  Constants.swift
//  Speedway Motors iOS Framework
//
//  Created by Josiah Ngu on 1/18/19.
//  Copyright © 2019 Derek Vogel. All rights reserved.
//

import Foundation
import UIKit
struct colorConstants {
    static let primaryColor = UIColor(red:0.28, green:0.04, blue:0.41, alpha:1.0)
    static let secondaryColor = UIColor(red:1.00, green:0.78, blue:0.17, alpha:1.0)
    static let errorColor = UIColor(red:1.00, green:0.00, blue:0.00, alpha:1.0)
}
struct locationsConstants {
    static let longitude = -96.726674
    static let latitude = 40.818214
}

struct loginConstants{
    static var login = ["","","","","","", ""]
    static var orderNo = ["","","","","", ""]
    static var orderVal = 0
    
}

struct openMapsConstants {
    static let googleMapURL = "comgooglemaps://?saddr=&daddr=Speedway+Motors+Victory+Lane+Lincoln+NE&directionsmode=driving"
    static let appleMapURL = "http://maps.apple.com/?q=Speedway+Motors+Victory+Lane+Lincoln+NE&saddr="
}
struct googleMapsKeys{
    static let apiKeys = "AIzaSyDQ-6c_46NBy9S0Wel2kl0lUxcmykyYA4g"
}

