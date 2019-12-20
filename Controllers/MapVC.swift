//
//  MapVC.swift
//  Map boy
//
//  Created by Fish on 15/11/2019.
//  Copyright © 2019 Fish. All rights reserved.
//

import UIKit
import MapKit

class MapVC: GrandVC, MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!

    override var locationsData: LocationsList? {
          didSet {
              updatePins()
          }
      }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
    }
    
    
    func updatePins() {
           guard let locations = locationsData?.studentLocations else { return }
           
           var annotations = [MKPointAnnotation]()
           for location in locations {
               
               let lat = CLLocationDegrees(location.latitude)
               let long = CLLocationDegrees(location.longitude)
               
               let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
               
               let first = location.firstName
               let last = location.lastName
               let link = location.mediaURL
               
               let annotation = MKPointAnnotation()
               annotation.coordinate = coordinate
               annotation.title = "\(first ?? "") \(last ?? "")"
               annotation.subtitle = link
               
               annotations.append(annotation)
           }
         
           self.map.addAnnotations(annotations)
       }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        let identifier = "annotation"
        var view: MKPinAnnotationView

        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }

        return view
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
       
}

