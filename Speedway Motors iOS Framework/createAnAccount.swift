//
//  createAnAccount.swift
//  Speedway Motors iOS Framework
//
//  Created by Hussain Al Lawati on 3/17/19.
//  Copyright © 2019 Derek Vogel. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON


class createAnAccount: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    var valid = true
    var validEmail = true
    var emailAddressText = ""
    let defaults = UserDefaults.standard
    var emailArray = [Any]()
    var passwordArray = [Any]()
    var userIDArray = [Any]()
    var orderIDArray = [Any]()
    var num = 0
    var em : [String] = ["","","","",""]
    
    
    struct keys {
        //Those are the keys for user default
        static let login = "login"
        static let password = "password"
        static let user_id = "user_id"
        static let order_number = "order_number"
    }
    
    
    func jsonData(){
        //getting data from the Json file
        let fileName = "login"
        let path = Bundle.main.path(forResource: fileName, ofType: "json")
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path!))
            let json = try JSON(data: data)
            num = json["_source"].count
            var i = 0
            
            //TODO fix the loop
            while i <  fileName.count{
                if let title = json["_source"][i]["login"].string{
                    em[i] = title
                    //loginConstants.login[i] = em[i]
                }
                
                i = i + 1
            }
        } catch {
            
            // handle error
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.layer.borderWidth = 1
        emailAddress.layer.borderWidth = 1
        password.layer.borderWidth = 1
        phoneNumber.layer.borderWidth = 1
        name.layer.borderColor = colorConstants.primaryColor.cgColor
        emailAddress.layer.borderColor = colorConstants.primaryColor.cgColor
        password.layer.borderColor = colorConstants.primaryColor.cgColor
        phoneNumber.layer.borderColor = colorConstants.primaryColor.cgColor
        
        name.delegate = self
        emailAddress.delegate = self
        password.delegate = self
        phoneNumber.delegate = self
        
        name.tag = 0
        emailAddress.tag = 1
        password.tag = 2
        phoneNumber.tag = 3
        
        if #available(iOS 12, *) {
            // iOS 12: Not the best solution, but it works.
            password.textContentType = .oneTimeCode
        } else {
            // iOS 11: Disables the autofill accessory view.
            // For more information see the explanation below.
            password.textContentType = .init(rawValue: "")
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        var checkValidation = true
        valid = true
        
        jsonData()
        
        
        
        name.layer.borderWidth = 0
        emailAddress.layer.borderWidth = 0
        password.layer.borderWidth = 0
        phoneNumber.layer.borderWidth = 0
        
        //Making sure that there is input in each of the required fields if there is no then a red border shows up and shows an error message
        if name.text?.count ?? 0 > 0 {
            checkValidation = true
        }
        else{
            print("No Name")
            name.layer.borderWidth = 1.0
            name.layer.borderColor = UIColor.red.cgColor
            checkValidation = false
        }
        
        if emailAddress.text?.count ?? 0 > 0{
            emailAddressText = emailAddress.text!
            emailAddressText = emailAddressText.trimmingCharacters(in: .whitespacesAndNewlines) //remove white space
            let last3letters =  String (emailAddressText.suffix(4))
            if emailAddressText.contains("@") == false{
                emailAddress.layer.borderWidth = 1.0
                emailAddress.layer.borderColor = UIColor.red.cgColor
                print("No @")
                checkValidation = false
            }
            if last3letters != ".com"{
                emailAddress.layer.borderWidth = 1.0
                emailAddress.layer.borderColor = UIColor.red.cgColor
                print("No .com")
                checkValidation = false
            }
            
        }
        else{
            emailAddress.layer.borderWidth = 1.0
            emailAddress.layer.borderColor = UIColor.red.cgColor
            print("No Email")
            checkValidation = false
        }
        
        if password.text?.count ?? 0 > 0 {
            if password.text?.count ?? 00 < 8 {
                password.layer.borderWidth = 1.0
                password.layer.borderColor = UIColor.red.cgColor
                print("Size of the password is not enough")
                checkValidation = false
            }
        }
        else{
            password.layer.borderWidth = 1.0
            password.layer.borderColor = UIColor.red.cgColor
            print("No password")
            checkValidation = false
        }
        
        
        if checkValidation == true{
            print("well done")
            name.layer.borderWidth = 0
            emailAddress.layer.borderWidth = 0
            password.layer.borderWidth = 0
            phoneNumber.layer.borderWidth = 0
            
            sendDataToJson()
            
            
            
        }
        else{
            errorMessage.text = "Please check the information that was entered"
            
        }
        
    }
    
    @IBAction func cancelSignUp(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //this function is to move from one textfield to another
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let txtTag:Int = textField.tag
        textField.resignFirstResponder()
        
        if let textFieldNxt = textField.superview?.viewWithTag(txtTag+1) as? UITextField {
            textFieldNxt.becomeFirstResponder()
        }else{
            print("done")
        }
        
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == phoneNumber){
            if(phoneNumber.text!.count >  9){
                phoneNumber.text = formattedNumber(number: textField.text!)
            }
        }
    }
    
    private func formattedNumber(number: String) -> String {
        //Formatting the phone Number as soon it is done editting
        let PhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "+1 (XXX) XXX-XXXX"
        
        var result = ""
        var index = PhoneNumber.startIndex
        for i in mask {
            if index == PhoneNumber.endIndex {
                break
            }
            if i == "X" {
                result.append(PhoneNumber[index])
                index = PhoneNumber.index(after: index)
            } else {
                result.append(i)
            }
        }
        return result
    }
    
    func sendDataToJson(){
        if validEmail == true{
            do{
                let user_id = Int.random(in: 100000 ... 999999)
                let order_number = ""
                
                
                //Checks if there is a value that already has been saved and add it to the array since it keeps on clearing when the page dissapeared
                if(defaults.array(forKey: keys.login) != nil){
                    emailArray.append(contentsOf: defaults.array(forKey: keys.login)!)
                    passwordArray.append(contentsOf: defaults.array(forKey: keys.password)!)
                    userIDArray.append(contentsOf: defaults.array(forKey: keys.user_id)!)
                    orderIDArray.append(contentsOf: defaults.array(forKey: keys.order_number)!)
                }
                
                
                ValidEmail()
                
                //saving the values to the user default and making sure that the email is valid
                if(valid){
                    
                    //appending the new values to the array
                    self.emailArray.append(emailAddress.text!.lowercased())
                    self.passwordArray.append(password.text!)
                    self.userIDArray.append(user_id)
                    self.orderIDArray.append(order_number)
                    
                    //in order reset the values of the user Default
                    //                defaults.removeObject(forKey: keys.login)
                    //                defaults.removeObject(forKey: keys.password)
                    //                defaults.removeObject(forKey: keys.user_id)
                    //                defaults.removeObject(forKey: keys.order_number)
                    
                    defaults.set(emailArray, forKey: keys.login)
                    defaults.set(passwordArray, forKey: keys.password)
                    defaults.set(userIDArray, forKey: keys.user_id)
                    defaults.set(orderIDArray, forKey: keys.order_number)
                    dismiss(animated: true, completion: nil) // to return to log in screen
                }
            }
        }
        else{
            //if the email is not valid
            emailAddress.layer.borderWidth = 1.0
            emailAddress.layer.borderColor = UIColor.red.cgColor
            print("Email is used before")
            errorMessage.text = "Please check the email address that was provided"
        }
    }
    
    func ValidEmail (){
        //TODO check the email if it has been used before
        print(emailArray)
        print(passwordArray)
        if(!emailArray.isEmpty){
            for i in 0 ... emailArray.count - 1{
                if((emailAddress.text?.lowercased().isEqual(to: emailArray[i]))!){
                    valid = false
                    emailAddress.layer.borderWidth = 1.0
                    emailAddress.layer.borderColor = UIColor.red.cgColor
                    errorMessage.text = "The email that was entered has already been used"
                }
            }
            //TODO check the email if it has been used in the Json file
            for i in 0 ... em.count - 1{
                if((emailAddress.text?.lowercased().isEqual(to: em[i]))!){
                    valid = false
                    emailAddress.layer.borderWidth = 1.0
                    emailAddress.layer.borderColor = UIColor.red.cgColor
                    errorMessage.text = "The email that was entered has already been used"
                }
            }
        }
    }
}
