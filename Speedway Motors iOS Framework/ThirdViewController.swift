//
//  ThirdViewController.swift
//  Speedway Motors iOS Framework
//
//  Created by Hussain Al Lawati on 10/30/18.
//  Copyright © 2018 Derek Vogel. All rights reserved.
//


import Foundation
import UIKit
import ZendeskSDK
import ZendeskCoreSDK
import ZendeskProviderSDK

class ThirdViewController: UINavigationController {
    var observer: NSKeyValueObservation?
    override func viewDidLoad() {
        super.viewDidLoad()
        presentHelpCenter()
    }
    
    func presentHelpCenter() {
        //creating a help center ui page and removing the contact us button
        let helpCenterUiConfig = HelpCenterUiConfiguration()
        helpCenterUiConfig.hideContactSupport = true
        
        //creating an article ui page and removing the contact us button
        let articleUiConfig = ArticleUiConfiguration()
        articleUiConfig.hideContactSupport = true
        
        //setting the article and the helpcenter together in order to be able to build them with their restrictiong ( removing the contact us button)
        let helpCenterViewController = HelpCenterUi.buildHelpCenterOverviewUi(withConfigs: [helpCenterUiConfig, articleUiConfig])
        
        //setting the page of controller as the help center UI
        self.setViewControllers([helpCenterViewController], animated: true)
        
        //having the logo on top of the page
        navigationController?.isToolbarHidden = true
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "NewWheel"))
        self.navigationItem.titleView?.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        self.navigationItem.titleView?.contentMode = .scaleAspectFit
        //it creates a viewcontroller in a view controller which helped us to remove the 'x' button
        observer = helpCenterViewController.observe(\UIViewController.navigationItem.leftBarButtonItem) { (viewController, change) in
            if viewController.navigationItem.leftBarButtonItem != nil {
                viewController.navigationItem.leftBarButtonItem = nil
                viewController.navigationItem.title = "Knowledge Base"
                viewController.navigationController?.setToolbarHidden(true, animated: true)
                viewController.navigationController?.toolbar.isTranslucent = true
            }
        }
    }
}
