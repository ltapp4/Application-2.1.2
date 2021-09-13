//
//  SignViewController.swift
//  Application 2.1.1
//
//  Created by Lauren Tapp on 9/13/21.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class SignViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var error1: UILabel!
    
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var error2: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUp()
    }
    
    func setUp() {
        error1.alpha = 0
        error2.alpha = 0
        
        //Utilies.styletextfield(firstNameTextField)
    }
    func validateSignUp() -> String? {
        // Check fields and validate
        
        // All filled in?
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Fill in all fields"
        }
        
        // Password secure?
        func isPasswordValid(_ password : String) -> Bool {
            let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,32}")
            return passwordTest.evaluate(with: password)
            
        }
        
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if isPasswordValid(cleanedPassword) == false {
            return "Password is not secure. Length >= 8 & Length < 32, must contain special character and number"
        }
        
        return nil
    }
    
    
    @IBAction func signUpTapped(_ sender: Any) {
        let error = validateSignUp()
        if error != nil {
            showError1(error!)
        } else {
            
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Create
            Auth.auth().createUser(withEmail: email, password: password) { result, err in
                if err != nil {
                    self.showError1((err?.localizedDescription)!)
                } else {
                    let db = Firestore.firestore()
                    db.collection("Users").addDocument(data: ["firstname":firstName, "lastname":lastName, "uid":result!.user.uid]) { (error) in
                        
                        if error != nil {
                            // Can change
                            self.showError1("First/Lastname couldn't be captured")
                        }
                    }
                }
            }
            
            // Transition
            self.transitionHome()
        }
    }
    
    
    @IBAction func loginTapped(_ sender: Any) {
        // TODO: Validate
        let error = validateLogin()
        if error != nil {
            showError2(error!)
        } else {
            
            // Clean
            let email = emailTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Transition
            signIn(email, password)
        }
    }
    
    func signIn(_ email : String, _ password : String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, err in
            if err != nil {
                self.error2.text = err!.localizedDescription
                self.error2.alpha = 1
            } else {
                self.transitionHome()
            }
        }
    }
    
    func validateLogin() -> String? {
        // Check fields and validate
        
        // All filled in?
        if emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Fill in all fields"
        }
        
        return nil
    }
    
    func showError2(_ message:String) {
        error2.text = message
        error2.alpha = 1
    }
    
    func showError1(_ message:String) {
        error1.text = message
        error1.alpha = 1
    }
    
    func transitionHome() {
        let homeVCont = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewC)
        view.window?.rootViewController = homeVCont
        view.window?.makeKeyAndVisible()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
