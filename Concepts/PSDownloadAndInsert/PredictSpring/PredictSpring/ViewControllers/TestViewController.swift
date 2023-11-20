//
//  TestViewController.swift
//  PredictSpring
//
//  Created by Madhumitha Loganathan on 18/11/23.
//

import UIKit

class TestViewController: UIViewController {

    private lazy var testButton : UIButton = {
        let btn = UIButton(frame: .zero)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Test", for: .normal)
        btn.backgroundColor = .systemBlue
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(testButton)
        // Do any additional setup after loading the view.
        
        NSLayoutConstraint.activate([
            testButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            testButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            testButton.heightAnchor.constraint(equalToConstant: 50),
            testButton.widthAnchor.constraint(equalToConstant: 120)
        ])

        testButton.addTarget(self, action: #selector(download), for: .touchUpInside)
        
    }
    
    
    @objc func download(_ sender: UIButton){
        print("Download file")
        
       
//        if let aStreamReader = StreamReader(path: Constants.fileUrl) {
//            defer {
//                aStreamReader.close()
//            }
//            while let line = aStreamReader.nextLine() {
//                print(line)
//            }
//        }else{
//            print("StreamReader is nil")
//        }
        
        guard let reader = LineReader(path: Constants.fileUrl) else {
            print("reader nil")
            return
        }
        reader.forEach { line in
            print(line.trimmingCharacters(in: .whitespacesAndNewlines))
        }
        
        
    }
        
        
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
