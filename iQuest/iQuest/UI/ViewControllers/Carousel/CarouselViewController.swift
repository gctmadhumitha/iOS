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
    private var titleView = UIStackView()
   
    private var titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle).bold()
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        label.text = ""
        label.textColor = AppColors.tertiaryTextColor
        return label
    }()
    
    private var captionLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        label.text = ""
        label.textColor = AppColors.tertiaryTextColor
        return label
    }()
    
    private var carouselData = [CarouselView.CarouselData]()
    private let backgroundImages: [String] = ["background-image1", "background-image2", "background-image3"]

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carouselView = CarouselView(pages: 3, delegate: self)
        carouselData.append(.init(image: UIImage(named: "background-image1"), caption: "Quiz", description: "Challenge yourself thousands of questions"))
        carouselData.append(.init(image: UIImage(named: "background-image2"), caption: "ChatGPT", description:"Ask ChatGPT and get your questions answered"))
        carouselData.append(.init(image: UIImage(named: "background-image3"), caption: "Facts", description: "Unlimited fun with cool facts"))
        setupUI()
        carouselView?.layoutIfNeeded()
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        carouselView?.updateView(with: carouselData)
    }
    
}

// MARK: - Setups

private extension CarouselViewController {
    
    func setupUI() {

       // view.backgroundColor = backgroundColors.first
        
        // basic setup
             view.backgroundColor = .white

             // Create a new gradient layer
             let gradientLayer = CAGradientLayer()
             // Set the colors and locations for the gradient layer
             //gradientLayer.colors = [UIColor.blue.cgColor, UIColor.red.cgColor]
        gradientLayer.colors = [AppColors.gradientColor1!.cgColor, AppColors.gradientColor2!.cgColor]
                gradientLayer.locations = [0.0, 1.0]

             // Set the start and end points for the gradient layer
             gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
             gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)

             // Set the frame to the layer
             gradientLayer.frame = view.frame

             // Add the gradient layer as a sublayer to the background view
             view.layer.insertSublayer(gradientLayer, at: 0)
        
        
        titleView.addArrangedSubview(titleLabel)
        titleView.addArrangedSubview(captionLabel)
        view.addSubview(titleView)
        view.addSubview(captionLabel)
        guard let carouselView = carouselView else { return }
        view.addSubview(carouselView)
        
        titleView.axis = .horizontal
        titleView.alignment = .center
        titleView.distribution = .fillProportionally
        titleView.spacing = 0
        titleView.isLayoutMarginsRelativeArrangement = true
        titleView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10)
        titleView.translatesAutoresizingMaskIntoConstraints = false
    
        titleLabel.text = "QuizQuest"
        titleLabel.font = UIFont(name: "Cream Cake", size: 70)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = AppColors.appTitleColor
        
        captionLabel.text = ""
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: 0),
            titleLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 0)
            
        ])
    
        
        NSLayoutConstraint.activate([
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            titleView.bottomAnchor.constraint(equalTo: carouselView.topAnchor, constant: -40),
            titleView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
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
            } else {
                self.view.backgroundColor = AppColors.secondaryBackground
            }
        }
    }
    
    func goToMainView() {
        self.navigationController?.pushViewController(TabBarViewController(), animated: true)
    }
}


#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct CarouselViewController_Preview: PreviewProvider {
    static var previews: some View {
        // view controller using programmatic UI
        CarouselViewController().showPreview()
    }
}
#endif

