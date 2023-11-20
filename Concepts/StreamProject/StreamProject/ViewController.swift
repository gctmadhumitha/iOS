//
//  ViewController.swift
//  StreamProject
//
//  Created by Madhumitha Loganathan on 18/11/23.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    var products = [Product]()
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
        var fileUrl = "https://drive.google.com/uc?export=download&id=16jxfVYEM04175AMneRlT0EKtaDhhdrrv"
        //x`
        //overriding with 500 file/
       // fileUrl = "https://drive.google.com/uc?export=download&id=1AMm2LVQ58lgA9G48qbt_KQw-OI-Ye80N"
        
        //5000
        //fileUrl = "https://drive.google.com/uc?export=download&id=1Za1GbXO8jDG8Q6eFdceZVI2A_UuZpYP9"
        
        guard let url = URL(string: fileUrl) else {
            return
        }
        var isHeaderLine = true
        var numberOfFields = 0
        var partialString = ""
        AF.streamRequest(url).responseStreamString { stream in
            switch stream.event {
            case let .stream(result):
                switch result {
                case let .success(string):
                    //print("Stream length ::" , string.count)
                    let lines = string.split(separator: "\n")
                    //print("total lines ", lines.count)
                    for line in lines {
                        print(line)
                        if self.products.count == 0 && isHeaderLine {
                            //ignores first line
                            isHeaderLine = false
                            numberOfFields = line.split(separator:",").count
                            continue
                        }
                        let isPartialLine = self.isPartialLine(line: String(line), numberOfFields: numberOfFields)
                        if isPartialLine {
                            print("Partial Line  ::  \(line)")
                        }
                        if !isPartialLine {
                            let fields = line.split(separator:",")
                            let product = self.createProduct(fields: fields)
                            self.products.append(product)
                        }else {
                            print("partial line ", line)
                            // If partialString is already present, create a combined string out of it.
                            if partialString.count > 0 {
                                var combinedLine = partialString + line
                                print("combinedLine ", combinedLine)
                                combinedLine = combinedLine.replacingOccurrences(of: "\n", with: "")
                                let fields = combinedLine.split(separator:",")
                                if fields.count == numberOfFields {
                                    let product = self.createProduct(fields: fields)
                                    print("partial line product ", product)
                                    self.products.append(product)
                                }else{
                                    print("PARSE ERROR ")
                                }
                                partialString = ""
                            }else // else add to partial string
                            {
                                partialString = String(describing: line)
                            }
                            print("partialString ", partialString)
                            
                            // TODO buffer partial line
                            
                        }
                        
                        // print(string)
                    }
                }
            case let .complete(completion):
                print(completion)
                print("Total products " , self.products.count)
            }
        }
        
        
        //        AF.streamRequest(url).validate()
        //            .responseStream { response in
        //              guard let data = response.value else { return }
        //
        //              let fullString = String(decoding: data, as: UTF8.self)
        //
        //              print(str)
        //              print(data)
        //          }
        //
    }
    
    
    func createProduct(fields: [Substring.SubSequence]) -> Product {
        let productId = String(describing: fields[0])
        let title = String(describing:fields[1])
        let listPrice = String(describing:fields[2])
        let salesPrice = String(describing:fields[3])
        let color = String(describing:fields[4])
        let size = String(describing:fields[5])
        return Product(productId: productId, title: title, listPrice: listPrice, salesPrice: salesPrice, color: color, size: size)
    }
    
    func isPartialLine(line: String, numberOfFields: Int) -> Bool {
        let fields = line.split(separator:",")
        if fields.count != numberOfFields {
            return true
        }
        if fields[0].count != 14 || !fields[0].starts(with: "99"){
            return true
        }
        
        return false
    }
    
}



struct Product: Codable, Identifiable {
    var productId: String
    var title: String
    var listPrice: String
    var salesPrice: String
    var color: String
    var size: String
    var id: String { productId}
}
