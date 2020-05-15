//
//  ViewController.swift
//  SSLPiningTest
//
//  Created by Hajji Anwer on 5/12/20.
//  Copyright © 2020 Hajji Anwer.

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if SSLPinningManager.shared.isJailbrokenDeviceOrEmulator(){
            DispatchQueue.main.async {
                self.alert()
            }
        }
        
        connectToGoogle()
    }
    
    func connectToGoogle(){
        SSLPinningManager.shared.enablePublicKeyPinning()
        let url = URL(string: "https://www.google.com")!
        SSLPinningManager.shared.session.request(url).responseData { (response) in
            if response.error == nil {
                print("success")
                print(response.response?.statusCode ?? 0)
            } else {
                print(response.error!)
            }
        }
    }

    func alert() {
        let alert = UIAlertController(title: "Warning", message: "application won't run on a jailbroken device or in emulator", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (_) in
            exit(0)
        }))
        self.present(alert,animated: true,completion: nil)
    }
}

