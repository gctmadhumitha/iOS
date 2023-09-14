//
//  CarouselViewController.swift
//  iQuest
//
//  Created by Madhumitha Loganathan on 11/09/23.
//

import UIKit

class CarouselViewController: UIViewController {

   
    // MARK: - Subviews
    
    private var carouselView: CarouselView?
    
    // MARK: - Properties
    
    private var carouselData = [CarouselView.CarouselData]()
    private let backgroundColors: [UIColor] = [#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), #colorLiteral(red: 0.4826081395, green: 0.04436998069, blue: 0.2024421096, alpha: 1), #colorLiteral(red: 0.1728022993, green: 0.42700845, blue: 0.3964217603, alpha: 1)]
    private let backgroundImages: [String] = ["background1", "background2", "background3"]
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carouselView = CarouselView(pages: 3, delegate: self)
        carouselData.append(.init(image: UIImage(named: "background1"), text: "SQuiz(e) your brain"))
        carouselData.append(.init(image: UIImage(named: "background2"), text: "Have fun with facts"))
        carouselData.append(.init(image: UIImage(named: "background1"), text: "Ask ChatGPT"))
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        carouselView?.configureView(with: carouselData)
    }
}

// MARK: - Setups

private extension CarouselViewController {
    
    func setupUI() {
        
        view.backgroundColor = backgroundColors.first
        
        guard let carouselView = carouselView else { return }
        view.addSubview(carouselView)
        carouselView.translatesAutoresizingMaskIntoConstraints = false
        carouselView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        carouselView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        carouselView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        carouselView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

// MARK: - CarouselViewDelegate

extension CarouselViewController: CarouselViewDelegate {
    func currentPageDidChange(to page: Int) {
        UIView.animate(withDuration: 0.7) {
            //self.view.backgroundColor = self.backgroundColors[page]
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: self.backgroundImages[page])!)
            
        }
    }
    
    func goToMainView() {
        self.navigationController?.pushViewController(TabBarViewController(), animated: true)
    }
}
