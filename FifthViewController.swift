//
//  FifthViewController.swift
//  Speedway Motors iOS Framework
//
//  Created by Hussain Al Lawati on 10/30/18.
//  Copyright © 2018 Derek Vogel. All rights reserved.
//

import Foundation
import WebKit
import UIKit
import SwiftyJSON

class FifthViewController: UIViewController {
    var em : [String] = ["","","","",""]
    var orders : [String] = ["","","","",""]
    var pass = ""
    var i = 0
    var num = 0
    let defaults = UserDefaults.standard
    let webview = WKWebView()
    @IBOutlet weak var wrongAccOrPassLabel: UILabel!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var createAnAccount: UIButton!
    var checkingAccount:Bool = false
    func jsonint2(){
        let fileName = "login"
        let path = Bundle.main.path(forResource: fileName, ofType: "json")
        
        do {
            print("first part\n")
            let data = try Data(contentsOf: URL(fileURLWithPath: path!))
            let json = try JSON(data: data)
            num = json["_source"].count
            //var title = ""
            //
//            if let stat = json["_source"]["line_items"][0]["item_status"].string{
//                defaults.set(stat, forKey: "status")
//            }
            while i <  fileName.count{
                if let title = json["_source"][i]["login"].string{
                    em[i] = title
                    orders[i] = json["_source"][i]["order_number"].string!
                    print("the title is", orders[i], "\n")
                    loginConstants.login[i] = em[i]
                    //defaults.set("Open", forKey: orders[i])
                }
                
                i = i + 1
            }
        } catch {
            
            // handle error
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "NewWheel"))
        self.navigationItem.titleView?.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        self.navigationItem.titleView?.contentMode = .scaleAspectFit
        emailText.tintColor = UIColor.black
        emailText.layer.borderWidth = 2
        emailText.layer.borderColor = colorConstants.primaryColor.cgColor
        passwordText.tintColor = UIColor.black
        passwordText.layer.borderWidth = 2
        passwordText.layer.borderColor = colorConstants.primaryColor.cgColor
        jsonint2()
        defaults.set("nil", forKey: "status")
//        print("the status is", defaults.string(forKey: "status") ?? "nil")
        if #available(iOS 12, *) {
            // iOS 12: Not the best solution, but it works.
            passwordText.textContentType = .oneTimeCode
        } else {
            // iOS 11: Disables the autofill accessory view.
            // For more information see the explanation below.
            emailText.textContentType = .init(rawValue: "")
            passwordText.textContentType = .init(rawValue: "")
        }
        
       
        
    }
    
   
    
    @IBAction func forgetPasswordUrl(_ sender: Any) {
        
        openUrl(urlString: "https://www.speedwaymotors.com/Account/ForgotPasswordRequest")
    }
    
    @IBAction func createAnAccount(_ sender: Any) {
        
    }
    
    @IBAction func logIn(_ sender: Any) {
        //loginSubmit
        webview.evaluateJavaScript("document.getElementById('LoginEmailAddress').value='\(emailText.text!)'",completionHandler: nil)
        webview.evaluateJavaScript("document.getElementById('LoginPassword').value='\(passwordText.text!)'",completionHandler: nil)
       webview.evaluateJavaScript("document.getElementById('loginForm').submit();")
//        {(result,error) in
//            let url = URL(string:"https://www.speedwaymotors.com/Account/orderHistory")
//
//            let request = URLRequest(url: url!)
//            self.webview.load(request)
//        }
        webview.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
            for cookie in cookies {
                print("\(cookie.name) is set to \(cookie.value)")
            }
        }
        if emailText.text != nil && passwordText.text != nil{

            if ((emailText.text == em[0]) || (emailText.text == em[1]) || (emailText.text == em[2]) || (emailText.text == em[3]) || (emailText.text == em[4])) && (passwordText.text == "gobigred"){
                UserDefaults.standard.setValue(true, forKey: "isLoggedIn")
                performSegue(withIdentifier: "FirstSeg", sender: self)
                if(emailText.text == em[0]){
                    loginConstants.orderVal = 0
                }
                else if(emailText.text == em[1]){
                    loginConstants.orderVal = 1
                }
                else if(emailText.text == em[2]){
                    loginConstants.orderVal = 2
                }
                else if(emailText.text == em[3]){
                    loginConstants.orderVal = 3
                }
                else if(emailText.text == em[4]){
                    loginConstants.orderVal = 4
                }
            }
                
            else{
                wrongAccOrPassLabel.text = "*Please enter a correct email address or password"
                passwordText.text = ""
                print("Invalid Credentials")
            }
        }
    }
    
    func openUrl(urlString : String!) {
        if let  websiteLink = NSURL(string: urlString) {
            UIApplication.shared.open(websiteLink as URL, options: [:], completionHandler: nil)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
