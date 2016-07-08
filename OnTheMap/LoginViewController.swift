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
    
    override func viewDidDisappear(animated: Bool) {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.hidden = true
    }
    
    @IBAction func udacityLoginPressed() {
        setUIEnabled(false)
        guard let email = emailTextField.text where email != "", let password = passwordTextField.text where password != "" else {
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
    
    private func completeLogin() {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("rootNavigationController") as! UINavigationController
        presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func udacitySignUp(sender: AnyObject) {
        if UIApplication.sharedApplication().canOpenURL(NSURL(string: UdacityClient.Constants.UdacitySignupURL)!) {
            UIApplication.sharedApplication().openURL(NSURL(string: UdacityClient.Constants.UdacitySignupURL)!)
        }
    }
}

extension LoginViewController {
    
    private func setUIEnabled(enabled: Bool) {
        udacityLoginButton.enabled = enabled
        emailTextField.enabled = enabled
        passwordTextField.enabled = enabled
        activityIndicator.hidden = enabled
        
        if enabled {
            activityIndicator.stopAnimating()
            udacityLoginButton.alpha = 1.0
        } else {
            activityIndicator.startAnimating()
            udacityLoginButton.alpha = 0.5
        }
    }
    
    private func configureBackground() {
        let gradientLayer = CAGradientLayer()
        view.backgroundColor = UIColor.orangeColor()
        gradientLayer.frame = self.view.bounds
        let color1 = UIColor.orangeColor().CGColor as CGColorRef
        let color2 = UIColor(red: 255.0/255.0, green: 195.0/255.0, blue: 61.0/255.0, alpha: 1.0).CGColor as CGColorRef
        gradientLayer.colors = [color2, color1]
        gradientLayer.locations = [0.0, 0.5]
        gradientLayer.frame = self.view.frame
        view.layer.insertSublayer(gradientLayer, atIndex: 0)
    }
}


