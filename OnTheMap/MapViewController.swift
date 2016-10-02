//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Sean Perez on 6/28/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import UIKit
import MapKit
import FBSDKLoginKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var locations = [StudentInformation]()
    var annotations = [MKPointAnnotation]()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.reloadData), name: NSNotification.Name(rawValue: "reloadData"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.mapView.delegate = self
        ParseClient.sharedInstance().getStudentLocations { (students, success, errorString) in
            if let students = students {
                self.getStudents(students)
            } else {
                UdacityClient.sharedInstance().displayErrorAlert(self, title: "Could not access student locations")
            }
        }
    }
    
    func getStudents(_ students: [StudentInformation]) {
        for student in students {
            if let lat = student.latitude, let long = student.longitude {
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                let first = student.firstName
                let last = student.lastName
                let mediaURL = student.mediaURL
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(first) \(last)"
                annotation.subtitle = mediaURL
                annotations.append(annotation)
            }
        }
        performUIUpdatesOnMain {
            self.mapView.addAnnotations(self.annotations)
        }
    }
    
    func reloadData() {
        ParseClient.sharedInstance().getStudentLocations { (students, success, errorString) in
            if errorString != nil {
                UdacityClient.sharedInstance().displayErrorAlert(self, title: "Could not obtain student locations")
            }
            
            if let students = students {
                performUIUpdatesOnMain({
                    UdacityClient.sharedInstance().clearAnnotations(self.mapView)
                    UdacityClient.sharedInstance().replaceAnnotations(students, mapView: self.mapView)
                })
            }
        }
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension MapViewController {

    @objc(mapView:viewForAnnotation:) func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(URL(string: toOpen)!)
            }
        }
    }
    
    func loadWaiting() {
        loadingView.isHidden = false
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        NotificationCenter.default.removeObserver(self)
    }
    
}

    


