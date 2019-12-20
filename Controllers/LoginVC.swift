//
//  LoginVC.swift
//  Map boy
//
//  Created by Fish on 14/11/2019.
//  Copyright © 2019 Fish. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @IBAction func login(_ sender: Any) {
        API.login(username: usernameInput.text!, password: passwordInput.text!) { (errString) in
             guard errString == nil else {
                 self.showAlert(title: "Error", message: errString!)
                 return
             }
             DispatchQueue.main.async {
                let vc = self.storyboard?.instantiateViewController(identifier: "CoreView")
                vc?.modalPresentationStyle = .fullScreen
                self.present(vc ?? UIViewController(), animated: true, completion: nil)
             }
         }
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

