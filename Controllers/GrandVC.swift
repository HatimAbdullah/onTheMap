//
//  GrandVC.swift
//  Map boy
//
//  Created by Fish on 15/11/2019.
//  Copyright © 2019 Fish. All rights reserved.
//

import UIKit

class GrandVC: UIViewController {
    
    var locationsData: LocationsList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadStudentLocations()
    }
    
    private func setupViews() {
        let AddLocation = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addLocationTapped(_:)))
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshLocationsTapped(_:)))
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(self.logoutTapped(_:)))
        
        navigationItem.rightBarButtonItems = [AddLocation, refreshButton]
        navigationItem.leftBarButtonItem = logoutButton
        navigationItem.title = "On the map"
        navigationController?.navigationBar.barTintColor = .systemPurple
        navigationController?.navigationBar.backgroundColor = .systemPurple
        
        let fontAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]
        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .normal)
        tabBarController?.tabBar.items?[0].title = "Map"
        tabBarController?.tabBar.items?[1].title = "Table"
    }
    
    @objc private func addLocationTapped(_ sender: Any) {
        let navController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddNav") as! UINavigationController
        
        present(navController, animated: true, completion: nil)
    }
    
    @objc private func refreshLocationsTapped(_ sender: Any) {
        loadStudentLocations()
    }
    
    @objc private func logoutTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Logout", message: "do you want to leave?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
            API.logout { (err) in
                guard err == nil else {
                    self.showAlert(title: "Error", message: err!)
                    return
                }
                self.dismiss(animated: true, completion: nil)
            }
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .destructive, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func loadStudentLocations() {
        API.getLocations { (data) in
            guard let data = data else {
                self.showAlert(title: "Error", message: "can't move")
                return
            }
            guard data.studentLocations.count > 0 else {
                self.showAlert(title: "Error", message: "there is nobody out there, you are all alone.")
                return
            }
            self.locationsData = data
        }
    }
    
}
