//
//  ViewController.swift
//  SSLPiningTest
//
//  Created by Hajji Anwer on 5/12/20.
//  Copyright © 2020 Hajji Anwer.

import UIKit
import Alamofire

class ViewController: UIViewController {

    var session = Session()
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://www.google.com")!
        SSLPinningManager.shared.testEnableCertificatesPinning()
        SSLPinningManager.shared.session.request(url).responseData { response in
            if response.error == nil {
                print("Success")
                print(response.response?.statusCode)
            } else {
                print("Error")
            }
        }
    }

}

