//
//  ViewController.swift
//  ConfigTest
//
//  Created by Anand Nigam on 05/02/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showConfigAlert()
    }

    func showConfigAlert() {
        let alert = UIAlertController(title: "Config Values", message: "Base URL - \(Config.baseURL)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
}

