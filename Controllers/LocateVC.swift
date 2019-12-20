//
//  locateVC.swift
//  Map boy
//
//  Created by Fish on 15/11/2019.
//  Copyright © 2019 Fish. All rights reserved.
//

import UIKit
import MapKit

class LocateVC: UIViewController {

    @IBOutlet weak var map: MKMapView!
    
    var location: StudentLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()

    }
    
    private func setupMap() {
           guard let location = location else { return }
           
           let lat = CLLocationDegrees(location.latitude)
           let long = CLLocationDegrees(location.longitude)
           
           let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
           
           let annotation = MKPointAnnotation()
           annotation.coordinate = coordinate
           annotation.title = location.mapString
           
           map.addAnnotation(annotation)
           
           let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
           map.setRegion(region, animated: true)
       }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
           
           let reuseId = "pin"
           
           var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
           
           if pinView == nil {
               pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
               pinView!.canShowCallout = true
               pinView!.pinTintColor = .red
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
               if let toOpen = view.annotation?.subtitle!,
                   let url = URL(string: toOpen), app.canOpenURL(url) {
                   app.open(url, options: [:], completionHandler: nil)
               }
           }
       }
    
    @IBAction func confirm(_ sender: Any) {
        
        API.postLocation(self.location!) { (err) in
                   guard err == nil else {
                       self.showAlert(title: "Error", message: err!)
                       return
                   }
                   
                   self.dismiss(animated: true, completion: nil)
               }
    }
}
