//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Sean Perez on 6/27/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: LoginTextField!
    @IBOutlet weak var udacityLoginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackground()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.isHidden = true
    }
    
    @IBAction func udacityLoginPressed() {
        setUIEnabled(false)
        guard let email = emailTextField.text , email != "", let password = passwordTextField.text , password != "" else {
            UdacityClient.sharedInstance().displayErrorAlert(self, title: "Please enter username and password")
            setUIEnabled(true)
            return
        }
       
        UdacityClient.sharedInstance().authenticateWithViewController(self, username: email, password: password) { (success, errorString) in
            if success {
                performUIUpdatesOnMain({ 
                    self.completeLogin()
                    self.setUIEnabled(true)
                })
            } else {
                UdacityClient.sharedInstance().displayErrorAlert(self, title: errorString!)
                self.setUIEnabled(true)
            }
        }
    }
    
    fileprivate func completeLogin() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "rootNavigationController") as! UINavigationController
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func udacitySignUp(_ sender: AnyObject) {
        if UIApplication.shared.canOpenURL(URL(string: UdacityClient.Constants.UdacitySignupURL)!) {
            UIApplication.shared.openURL(URL(string: UdacityClient.Constants.UdacitySignupURL)!)
        }
    }
}

extension LoginViewController {
    
    fileprivate func setUIEnabled(_ enabled: Bool) {
        udacityLoginButton.isEnabled = enabled
        emailTextField.isEnabled = enabled
        passwordTextField.isEnabled = enabled
        activityIndicator.isHidden = enabled
        
        if enabled {
            activityIndicator.stopAnimating()
            udacityLoginButton.alpha = 1.0
        } else {
            activityIndicator.startAnimating()
            udacityLoginButton.alpha = 0.5
        }
    }
    
    fileprivate func configureBackground() {
        let gradientLayer = CAGradientLayer()
        view.backgroundColor = UIColor.orange
        gradientLayer.frame = self.view.bounds
        let color1 = UIColor.orange.cgColor as CGColor
        let color2 = UIColor(red: 255.0/255.0, green: 195.0/255.0, blue: 61.0/255.0, alpha: 1.0).cgColor as CGColor
        gradientLayer.colors = [color2, color1]
        gradientLayer.locations = [0.0, 0.5]
        gradientLayer.frame = self.view.frame
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}


