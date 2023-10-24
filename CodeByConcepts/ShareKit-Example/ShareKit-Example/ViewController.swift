//
//  ViewController.swift
//  ShareKit-Example
//
//  Created by Madhumitha Loganathan on 22/09/23.
//

import UIKit


class ViewController: UIViewController {

    private let button : UIButton = {
       let button = UIButton()
        button.backgroundColor = .purple
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Tap Me", for: .normal)
       return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        button.center = view.center
        button.addTarget(self, action: #selector(presentShareSheet), for: .touchUpInside)
        view.addSubview(button)
    }

    @objc private func presentShareSheet(){
        guard let image = UIImage(systemName: "person"), let url = URL(string: "https://www.google.com") else {
            return
        }
        
        let shareSheetVC = UIActivityViewController(
            activityItems: [
                image,
                url
            ],
            applicationActivities: nil)
        present(shareSheetVC, animated:true)
    }

}

