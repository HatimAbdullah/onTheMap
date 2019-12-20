//
//  TableVC.swift
//  Map boy
//
//  Created by Fish on 15/11/2019.
//  Copyright © 2019 Fish. All rights reserved.
//

import UIKit

class TableVC: GrandVC, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    override var locationsData: LocationsList? {
        didSet {
            guard let locationsData = locationsData else { return }
            locations = locationsData.studentLocations
        }
    }
    
    var locations: [StudentLocation] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .yellow
        self.tableView.register(StudentCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? StudentCell {
            cell.studentLocation = locations[indexPath.row]
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let studentLocation = locations[indexPath.row]
        guard let url = URL(string: studentLocation.mediaURL), UIApplication.shared.canOpenURL(url) else {
            self.showAlert(title: "Error", message: "no go")
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
