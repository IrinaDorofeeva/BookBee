//
//  ViewController.swift
//  BookBee
//
//  Created by Mac on 6/13/17.
//  Copyright © 2017 Irina Dorofeeva. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {

    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    
    
    
    @IBAction func loginTapped(_ sender: Any) {
        
        if (!CheckInput()){
        
        return }
        
        
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            print("We tried to sign in")
            if error != nil{
                print ("error:\(error)")
                Utilities().ShowAlert(title: "Error", message: error!.localizedDescription, vc: self)
                
           
                
            } else {
                print("Signed in")
                self.performSegue(withIdentifier: "signIn", sender: nil)
            }
            
        }
        
        
    }
    
  
    @IBAction func signUpTapped(_ sender: Any) {
        if (!CheckInput()){
            return }
        
        let alert = UIAlertController(title: "Register", message: "Please confirm your password...", preferredStyle: .alert)
        alert.addTextField { (textField) in textField.placeholder = "password" }
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in
                let passConfim = alert.textFields![0] as UITextField
                if (passConfim.text!.isEqual(self.passwordTextField.text!)){
                
                    
                    
                    Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { (user, error) in
                        print("We tried to create a user")
                        if error != nil{
                            print ("error:\(error)")
                        Utilities().ShowAlert(title: "Error", message: (error?.localizedDescription)!, vc: self)
                            return
                        }
                        else {
                            print ("user created")
                            
                            
                                Database.database().reference().child("users").child((user?.uid)!).child("email").setValue(user?.email)
                            Database.database().reference().child("users").child((user?.uid)!).child("name").setValue(self.nameTextField.text)
                            
                            //self.performSegue(withIdentifier: "signIn", sender: nil)
                            self.dismiss(animated: true, completion: nil)
                        }
                    })
                    
                    
                    
                    
                }
                
                else {
               Utilities().ShowAlert(title: "Error", message: "Passwords not the same!" , vc: self)
                }

            
            }))
        
        self.present(alert, animated: true, completion: nil)
    
    }
    
    
    func CheckInput () -> Bool{
        if ((emailTextField.text?.characters.count)! < 5){
            emailTextField.backgroundColor = UIColor.init(red: 0.8, green: 0, blue: 0, alpha: 0.2)
            return false
        }
        else {
        emailTextField.backgroundColor = UIColor.white
        }
        
        if ((passwordTextField.text?.characters.count)! < 5){
            passwordTextField.backgroundColor = UIColor.init(red: 0.8, green: 0, blue: 0, alpha: 0.2)
            return false
        }
        else {
            passwordTextField.backgroundColor = UIColor.white
        }
        return true
    }

        
        
    @IBAction func forgotPasswordTapped(_ sender: Any) {
        if (!emailTextField.text!.isEmpty){
        let email = self.emailTextField.text
            Auth.auth().sendPasswordReset(withEmail: email!, completion: {(error) in
                if let error = error{
                    Utilities().ShowAlert(title: "Error", message: error.localizedDescription, vc: self)
                    return
                }
            Utilities().ShowAlert(title:"Success!", message: "Please check your email!" , vc: self)
            })
        
        
    }
    }
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

