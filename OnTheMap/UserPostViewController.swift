//
//  UserPostViewController.swift
//  OnTheMap
//
//  Created by Sean Perez on 7/1/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import UIKit
import MapKit

class UserPostViewController: UIViewController {

    @IBOutlet weak var stackViewLabel: UIStackView!
    @IBOutlet weak var cancelPostButton: UIButton!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var findOnMapButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var bottomTabBar: UIView!
    @IBOutlet weak var topTabBar: UIView!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var submitPostButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var latitude = CLLocationDegrees()
    var longitude = CLLocationDegrees()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setActivityIndicatorView(false)
        setUITextFieldForInitialView()
    }
    
    @IBAction func findOnMapPressed(_ sender: AnyObject) {
         self.setActivityIndicatorView(true)
        if let locationText = locationTextField.text , locationText != "" {
            forwardGeocoding(locationText)
             self.setActivityIndicatorView(false)
        } else {
            UdacityClient.sharedInstance().displayErrorAlert(self, title: "Please enter a location")
            self.setActivityIndicatorView(false)
            
        }
    }
    
    func forwardGeocoding(_ address: String) {
        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if let placemark = placemarks?[0] {
                self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
                let locationCoordinate = placemark.location!.coordinate as CLLocationCoordinate2D
                self.setMapViewRegionAndScale(locationCoordinate)
                self.setUIElementsForMapViewing()
            } else {
                UdacityClient.sharedInstance().displayErrorAlert(self, title: "Unable to process your location. Please try again!")
                self.locationTextField.text = ""
            }
        })
    }
    
    func setMapViewRegionAndScale(_ location: CLLocationCoordinate2D) {
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        self.latitude = location.latitude
        self.longitude = location.longitude
    }
    
    @IBAction func submitPostPressed(_ sender: AnyObject) {
        
        guard let mediaURL = linkTextField.text , mediaURL != "" else {
            UdacityClient.sharedInstance().displayErrorAlert(self, title: "Please enter a link to share")
            return
        }
        
        guard let uniqueID = UdacityClient.sharedInstance().uniqueID, let firstName = UdacityClient.sharedInstance().firstName, let lastName = UdacityClient.sharedInstance().lastName, let mapString = locationTextField.text else {
            UdacityClient.sharedInstance().displayErrorAlert(self, title: "There was an error. Please try again")
            return
        }
        
        ParseClient.sharedInstance().postStudentLocation(uniqueID, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude, completionHandler: { (success, errorString) in
                if success {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    UdacityClient.sharedInstance().displayErrorAlert(self, title: "There was an error submitting your post. Please try again")
                }
            })
    }

    @IBAction func cancelPost(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}

extension UserPostViewController {
    
    func setActivityIndicatorView(_ enabled: Bool) {
        if enabled {
            self.activityIndicator.isHidden = !enabled
            self.activityIndicator.startAnimating()
        } else {
            self.activityIndicator.isHidden = !enabled
            self.activityIndicator.stopAnimating()
        }
    }
    
    func setUITextFieldForInitialView() {
        let attributedString = [NSForegroundColorAttributeName: UIColor.white]
        locationTextField.attributedPlaceholder = NSAttributedString(string: "Enter Your Location Here", attributes: attributedString)
    }
    
    func setUIElementsForMapViewing() {
        let attributedString = [NSForegroundColorAttributeName: UIColor.white]
        findOnMapButton.isHidden = true
        submitPostButton.isHidden = false
        bottomTabBar.backgroundColor = UIColor.clear
        topTabBar.backgroundColor = UIColor(red: 65.0/255.0, green: 124.0/255.0, blue: 193.0/255.0, alpha: 0.85)
        linkTextField.isHidden = false
        linkTextField.attributedPlaceholder = NSAttributedString(string: "Enter a Link to Share Here", attributes: attributedString)
        stackViewLabel.isHidden = true
        cancelPostButton.setTitleColor(UIColor.white, for: UIControlState())
        mapView.isHidden = false
    }
}
