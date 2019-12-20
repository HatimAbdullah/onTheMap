//
//  AddVC.swift
//  Map boy
//
//  Created by Fish on 15/11/2019.
//  Copyright © 2019 Fish. All rights reserved.
//

import UIKit
import CoreLocation

class AddVC: UIViewController {

    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var link: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViesws()
        configureKeyboardDismissall()
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
          
           subscribeToNotificationsObserver()
       }
       
       override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           
           unsubscribeFromNotificationsObserver()
       }

    private func setupViesws() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action:  #selector(self.cancel(_:)))
        navigationItem.leftBarButtonItem?.tintColor = .systemYellow
        navigationController?.navigationBar.barTintColor = .systemPurple
        navigationController?.navigationBar.backgroundColor = .systemPurple
     }
     
     @objc func cancel(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
     }

    @IBAction func findLocation(_ sender: Any) {
        guard let location = location.text, let mediaLink = link.text, location != "", mediaLink != "" else {
                   self.showAlert(title: "what", message: "how")
                   return
               }
        
        let studentLocation = StudentLocation.init(createdAt: "",
                                                          firstName: nil,
                                                          lastName: nil,
                                                          latitude: 0,
                                                          longitude: 0,
                                                          mapString: location,
                                                          mediaURL: mediaLink,
                                                          objectId: "",
                                                          uniqueKey: "",
                                                          updatedAt: "")
               goToConfirm(studentLocation)
    }
    
    private func goToConfirm(_ location: StudentLocation) {
        let geocoder = CLGeocoder()
        let indicator = self.startAnActivityIndicator()
        geocoder.geocodeAddressString(location.mapString) { (placeMarks, _) in
            indicator.stopAnimating()
            guard let place = placeMarks else {
                self.showAlert(title: "Error", message: "can't find the location. that is not a real place")
                return
            }
            
            var studentLocation = location
            studentLocation.longitude = Float((place.first!.location?.coordinate.longitude)!)
            studentLocation.latitude = Float((place.first!.location?.coordinate.latitude)!)
            
            let vc = self.storyboard?.instantiateViewController(identifier: "locateVC") as! LocateVC
            vc.location = studentLocation
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func startAnActivityIndicator() -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .large)
           self.view.addSubview(indicator)
           self.view.bringSubviewToFront(indicator)
           indicator.center = self.view.center
           indicator.hidesWhenStopped = true
           indicator.startAnimating()
           return indicator
       }
    
    private func configureKeyboardDismissall() {
           let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
           tap.cancelsTouchesInView = false
           
           view.addGestureRecognizer(tap)
       }
       
       @objc func dismissKeyboard() {
           view.endEditing(true)
       }
}
