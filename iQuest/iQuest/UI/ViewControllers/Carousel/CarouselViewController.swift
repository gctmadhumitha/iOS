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
    private lazy var logoView = UIImageView()

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
    //private let backgroundColors: [UIColor] = [#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), #colorLiteral(red: 0.4826081395, green: 0.04436998069, blue: 0.2024421096, alpha: 1), #colorLiteral(red: 0.1728022993, green: 0.42700845, blue: 0.3964217603, alpha: 1)]
    private let backgroundImages: [String] = ["background-image1", "background-image2", "background-image3"]
    private let backgroundColors: [UIColor] =
        [UIColor(hex: "#74ade0ff") ?? AppColors.primaryBackground,
         UIColor(hex: "#fda76eff") ?? AppColors.primaryBackground,
         UIColor(hex:"#d06c8aff") ?? AppColors.primaryBackground]
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carouselView = CarouselView(pages: 3, delegate: self)
        carouselData.append(.init(image: UIImage(named: "background-image1"), caption: "Quiz", description: "Challenge yourself thousands of questions"))
        carouselData.append(.init(image: UIImage(named: "background-image2"), caption: "Facts", description: "Unlimited fun with facts"))
        carouselData.append(.init(image: UIImage(named: "background-image3"), caption: "ChatGPT", description:"Ask AI to know more"))
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

        view.backgroundColor = backgroundColors.first
        titleView.addArrangedSubview(logoView)
        titleView.addArrangedSubview(titleLabel)
        titleView.addArrangedSubview(captionLabel)
        view.addSubview(titleView)
        
        view.addSubview(captionLabel)
        titleView.addArrangedSubview(logoView)
        titleView.addArrangedSubview(titleLabel)
        titleView.addArrangedSubview(captionLabel)
        guard let carouselView = carouselView else { return }
        view.addSubview(carouselView)
        
        titleView.axis = .horizontal
        titleView.alignment = .center
        titleView.distribution = .fillProportionally
        titleView.spacing = 0
        titleView.isLayoutMarginsRelativeArrangement = true
        titleView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10)
        titleView.translatesAutoresizingMaskIntoConstraints = false
    
        titleLabel.text = "Quiz Ninja"
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = AppColors.appTitleColor
        
        captionLabel.text = ""
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleView.addArrangedSubview(logoView)
        titleView.addArrangedSubview(titleLabel)
        
        logoView.image = UIImage(named: "AppLogoWhite")
        logoView.contentMode = .scaleAspectFit
        logoView.clipsToBounds = true
        logoView.layer.cornerRadius = 24
        logoView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            logoView.topAnchor.constraint(equalTo: titleView.topAnchor, constant: 0),
            logoView.widthAnchor.constraint(equalToConstant: view.frame.width/6),
            logoView.heightAnchor.constraint(equalToConstant: view.frame.width/6),
            logoView.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 0),
        ])

        NSLayoutConstraint.activate([
           // titleLabel.leadingAnchor.constraint(equalTo: logoView.trailingAnchor, constant: 0),
           // titleLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: 0),
            titleLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 0),
            titleLabel.widthAnchor.constraint(equalToConstant: 180)
        ])
         
//        NSLayoutConstraint.activate([
//            captionLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 20),
//            captionLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -20),
//            captionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
//            captionLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 0)
//        ])
        
        NSLayoutConstraint.activate([
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
                self.view.backgroundColor = self.backgroundColors[page]
            } else {
                self.view.backgroundColor = UIColor.systemBackground
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

