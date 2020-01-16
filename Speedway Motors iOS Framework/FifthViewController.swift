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
import UserNotifications
class FifthViewController: UIViewController, UITextFieldDelegate {
    
    
    var em : [String] = ["","","","",""]
    var orders : [String] = ["","","","",""]
    var pass = ""
    var i = 0
    var num = 0
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var wrongAccOrPassLabel: UILabel!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var createAnAccount: UIButton!
    var checkingAccount:Bool = false
    
    var emailArray = [String]()
    var passwordArray = [String]()
    
    //    func userEmail(email: Any) {
    //        emailArray = email
    //    }
    //
    //    func userPassword(password: Any) {
    //        passwordArray = password
    //    }
    
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
            while i <  num{
                if let title = json["_source"][i]["login"].string{
                    em[i] = title
                    orders[i] = json["_source"][i]["order_number"].string!
                    print("the title is", em[i], "\n")
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
        emailText.text = ""
        passwordText.text = ""
        emailText.delegate = self
        passwordText.delegate = self
        emailText.tag = 0
        passwordText.tag = 1

        
        
        
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
    //func opens the browser of the official website
    @IBAction func forgetPasswordUrl(_ sender: Any) {
        
        openUrl(urlString: "https://www.speedwaymotors.com/Account/ForgotPasswordRequest")
    }
    
    @IBAction func createAnAccount(_ sender: Any) {
        //this func must stay in order to perform the delegation to create an account page
    }
    
    //In order to go next in TextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let txtTag:Int = textField.tag
        textField.resignFirstResponder()
        
        if let textFieldNxt = textField.superview?.viewWithTag(txtTag+1) as? UITextField {
            textFieldNxt.becomeFirstResponder()
        }else{
            //As soon there is no textfield left as soon done is pressed it will go to log in functionality
            logIn(UIButton.self)
        }
        
        return false
    }
    
    @IBAction func logIn(_ sender: Any) {
        var notValid = false
        //recieves all of the data that was saved in the user default
        if(defaults.array(forKey: "login") != nil){
            emailArray = (defaults.array(forKey: "login") ?? nil)! as! [String]
            passwordArray = (defaults.array(forKey: "password") ?? nil)! as! [String]
        }
        
        //if the eamil and password fields are not empty
        if emailText.text != nil && passwordText.text != nil{
            //check if the email is equals to the value in the first array em and password = gobigred
            if ((emailText.text == em[0]) || (emailText.text == em[1]) || (emailText.text == em[2]) || (emailText.text == em[3]) || (emailText.text == em[4])) && (passwordText.text == "gobigred"){
                UserDefaults.standard.setValue(true, forKey: "isLoggedIn")
                notValid = true
                wrongAccOrPassLabel.text = ""
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
                
                
                //if the emailarray is not empty
            else if (!emailArray.isEmpty){
                //email label is not empty
                if(!emailText.text!.isEmpty){
                    //them it will check if the email and password is equals any of the saved emails and password with the same index
                    for i in 0 ... emailArray.count - 1{//saving the values to the user default
                        if(((emailText.text?.isEqual(to: emailArray[i]))!)&&((passwordText.text?.isEqual(to: passwordArray[i]))!)){
                            UserDefaults.standard.setValue(true, forKey: "isLoggedIn")
                            notValid = true
                            wrongAccOrPassLabel.text = ""
                            loginConstants.orderVal = 5
                            
                            performSegue(withIdentifier: "FirstSeg", sender: self)
                            print("Yes")
                        }
                    }
                }
            }
            print(loginConstants.orderVal)
            //if it is not valid then an error will show up
            if (!notValid){
                
                wrongAccOrPassLabel.text = "*Please enter a correct email address or password"
                print("Invalid Credentials")
            }
        }
    }
    //this func helps to open website using Safari
    func openUrl(urlString : String!) {
        if let  websiteLink = NSURL(string: urlString) {
            UIApplication.shared.open(websiteLink as URL, options: [:], completionHandler: nil)
        }
    }
    //as soon the user clicks on the screen the keyboard goes down
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
