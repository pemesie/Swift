import UIKit
import ZDCChat


//we need to change the UI of the page
class SecondViewController:  UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Phone: UITextField!
    
    // actions when user click start live chat
    @IBAction func pushChat(sender: AnyObject) {
        // check if user has enter valid pre chat info
        if(isValidEmail(Str: Email.text!) && !(Name.text ?? "").isEmpty){
            // config for starting the livechat
        ZDCChat.start(in: self.navigationController, withConfig: { config in
            //Desiging the UI design of the chat
            ZDCVisitorChatCell.appearance().bubbleBorderColor = colorConstants.primaryColor
            ZDCVisitorChatCell.appearance().bubbleCornerRadius = 8
            ZDCAgentChatCell.appearance().bubbleCornerRadius = 8
            ZDCVisitorChatCell.appearance().bubbleColor = colorConstants.primaryColor
            ZDCVisitorChatCell.appearance().textColor = .white
            ZDCChatUI.appearance().tintColor = colorConstants.primaryColor
            ZDCChat.instance().overlay.setEnabled(false)
        })
        ZDCChat.instance().overlay.setEnabled(false)
        ErrorLabel.text = ""
            Name.layer.borderWidth = 0
            Email.layer.borderWidth = 0
        //Update user info on zopim
        ZDCChat.updateVisitor { user in
            user?.name = self.Name.text
            user?.email = self.Email.text
            if(!(self.Phone.text ?? "").isEmpty){
                user?.phone = self.Phone.text
            }
            
        }
        //setting the logo in the center of the page in the ZD chat
        ZDCChat.instance()?.chatViewController.navigationItem.titleView = UIImageView(image: UIImage(named: "NewWheel"))
        ZDCChat.instance()?.chatViewController.navigationItem.titleView?.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        ZDCChat.instance()?.chatViewController.navigationItem.titleView?.contentMode = .scaleAspectFit
        
        } else{
            //  if user name field is empty
            if((Name.text ?? "").isEmpty){
                ErrorLabel.text = "Name field is required"
                Name.layer.borderColor = colorConstants.errorColor.cgColor
                Email.layer.borderColor = colorConstants.primaryColor.cgColor
                print("LiveChat form : EmptyField")
            }
            // email field is empty
            else if ((Email.text ?? "").isEmpty){
                ErrorLabel.text = "Email field is required"
                Email.layer.borderColor = colorConstants.errorColor.cgColor
                Name.layer.borderColor = colorConstants.primaryColor.cgColor
                print("LiveChat form : EmptyField")
            }
            // if invalid email
            else if(!isValidEmail(Str: Email.text!)){
                Name.layer.borderColor = colorConstants.primaryColor.cgColor
                Email.layer.borderColor = colorConstants.errorColor.cgColor
                ErrorLabel.text = "Please enter a valid email"
                print("LiveChatForm: Email Not Valid")
            }
            
            
        }
    }
    @IBOutlet weak var ErrorLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // initial styling for all the text field
        Name.layer.borderWidth = 2
        Email.layer.borderWidth = 2
        Phone.layer.borderWidth = 2

        Name.layer.borderColor = colorConstants.primaryColor.cgColor
        Email.layer.borderColor = colorConstants.primaryColor.cgColor
        Phone.layer.borderColor = colorConstants.primaryColor.cgColor
        
        Name.delegate = self
        Email.delegate = self
        Phone.delegate = self
        Name.tag = 0
        Email.tag = 1
        Phone.tag = 2 
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "NewWheel"))
        self.navigationItem.titleView?.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        self.navigationItem.titleView?.contentMode = .scaleAspectFit
    }
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // check if user has entered valid email in the form of ***@***.***
    func isValidEmail(Str:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}\\s*"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: Str)
    }
    
    // change to the next field when the user press next on keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
}
