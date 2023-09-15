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
    private var titleView = UIView()
    private var tableView = UITableView()
    private var titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle).bold()
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        label.text = ""
        label.textColor = AppColors.tertiaryTextColor
        return label
    }()
    
    private var carouselData = [CarouselView.CarouselData]()
    //private let backgroundColors: [UIColor] = [#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), #colorLiteral(red: 0.4826081395, green: 0.04436998069, blue: 0.2024421096, alpha: 1), #colorLiteral(red: 0.1728022993, green: 0.42700845, blue: 0.3964217603, alpha: 1)]
    private let backgroundImages: [String] = ["background-image1", "background-image2", "background-image3"]
    private let backgroundColors: [UIColor] =
        [UIColor(hex: "#72aadeff") ?? AppColors.primaryBackground,
         UIColor(hex: "#fdaa71ff") ?? AppColors.primaryBackground,
         UIColor(hex:"#d06c8aff") ?? AppColors.primaryBackground]
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carouselView = CarouselView(pages: 3, delegate: self)
        carouselData.append(.init(image: UIImage(named: "background-image1"), text: "SQuiz(e) your brain"))
        carouselData.append(.init(image: UIImage(named: "background-image2"), text: "Have fun with facts"))
        carouselData.append(.init(image: UIImage(named: "background-image3"), text: "Ask ChatGPT"))
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
        titleView.addSubview(titleLabel)
        view.addSubview(titleView)
        guard let carouselView = carouselView else { return }
        view.addSubview(carouselView)
        
        titleLabel.text = "Did you Know!"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -20),
            titleLabel.topAnchor.constraint(equalTo: titleView.topAnchor, constant: 0),
            titleLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 0),
            titleLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
         
        titleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            titleView.bottomAnchor.constraint(equalTo: carouselView.topAnchor, constant: -40)
        ])
        
        carouselView.translatesAutoresizingMaskIntoConstraints = false
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
            if let image = UIImage(named: self.backgroundImages[page]) {
                self.view.backgroundColor = UIColor(patternImage: image)
                self.view.backgroundColor = self.backgroundColors[page]
            }else {
                self.view.backgroundColor = UIColor.systemBackground
            }
            
        }
    }
    
    func goToMainView() {
        self.navigationController?.pushViewController(TabBarViewController(), animated: true)
    }
}
