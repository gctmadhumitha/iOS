//
//  CarouselView.swift
//  iQuest
//
//  Created by Madhumitha Loganathan on 11/09/23.
//

import UIKit

protocol CarouselViewDelegate {
    func currentPageDidChange(to page: Int)
    func goToMainView()
}

class CarouselView: UIView {
    
    struct CarouselData {
        let image: UIImage?
        let caption: String
        let description: String
    }
    
    let widthMultiplier = 0.6
    let heightMultiplier = 0.5
    
    // MARK: - Subviews

    
    private lazy var carouselCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.showsHorizontalScrollIndicator = false
        collection.isPagingEnabled = true
        collection.dataSource = self
        collection.delegate = self
        collection.register(CarouselCollectionViewCell.self, forCellWithReuseIdentifier: CarouselCollectionViewCell.cellId)
        collection.backgroundColor = .clear
        return collection
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .white
        return pageControl
    }()
    
    private lazy var getStartedButton: UIButton = {
        let button  = UIButton(type: .system)
        button.frame = CGRect(x: 20, y: 20, width: 100, height: 50)
        button.setTitle("Get Started", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3).bold()
        button.backgroundColor = UIColor(hex: "#fdc921ff")//AppColors.secondaryButtonColor
        button.layer.cornerRadius = AppConstants.buttonCornerRadius
        return button
    }()
    // MARK: - Properties
    
    private var pages: Int
    private var delegate: CarouselViewDelegate?
    private var carouselData = [CarouselData]()
    private var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            delegate?.currentPageDidChange(to: currentPage)
        }
    }
    
    // MARK: - Initializers
    
    init(pages: Int, delegate: CarouselViewDelegate?) {
        self.pages = pages
        self.delegate = delegate
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setups

private extension CarouselView {
    
    func setupUI() {
        backgroundColor = .clear
        setupCollectionView()
        setupPageControl()
        setupStartButton()
       
    }
    
    func setupCollectionView() {
        let collectionViewCellHeight  = UIScreen.main.bounds.height * heightMultiplier
        let carouselLayout = UICollectionViewFlowLayout()
        carouselLayout.scrollDirection = .horizontal
        carouselCollectionView.collectionViewLayout = carouselLayout
        addSubview(carouselCollectionView)
      
        carouselCollectionView.translatesAutoresizingMaskIntoConstraints = false
        carouselCollectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        carouselCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        carouselCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        carouselCollectionView.heightAnchor.constraint(equalToConstant: CGFloat(collectionViewCellHeight)).isActive = true
    }
    
    func setupPageControl() {
        addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.topAnchor.constraint(equalTo: carouselCollectionView.bottomAnchor, constant: 8).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pageControl.widthAnchor.constraint(equalToConstant: 150).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
        pageControl.numberOfPages = pages
    }
    
    func setupStartButton() {
        addSubview(getStartedButton)
        print(" UIScreen.main.bounds.size \( UIScreen.main.bounds.size)")
        print("frame size is :: \(frame.width)")
        
        getStartedButton.addTarget(self, action: #selector(gotoMainView(_:)), for: .touchUpInside)
        getStartedButton.translatesAutoresizingMaskIntoConstraints = false
        getStartedButton.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 8).isActive = true
        getStartedButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        getStartedButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        getStartedButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40).isActive = true
        getStartedButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40).isActive = true
    
    }
    
}


extension CarouselView {
    @objc func gotoMainView(_ sender:UIButton!) {
        delegate?.goToMainView()
    }
}

// MARK: - UICollectionViewDataSource

extension CarouselView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carouselData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCollectionViewCell.cellId, for: indexPath) as? CarouselCollectionViewCell else { return UICollectionViewCell() }
        
        let image = carouselData[indexPath.row].image
        let caption = carouselData[indexPath.row].caption
        let description = carouselData[indexPath.row].description
        
        cell.configure(image: image, caption: caption, description: description)
        
        return cell
    }
}

// MARK: - UICollectionView Delegate

extension CarouselView: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentPage = getCurrentPage()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        currentPage = getCurrentPage()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentPage = getCurrentPage()
    }
}

// MARK: - Public

extension CarouselView {
    
    // Update view constraints based on frame sizes.
    public func updateView(with data: [CarouselData]) {
        
        
        let collectionViewCellWidth = carouselCollectionView.frame.width * widthMultiplier
        let collectionViewCellHeight = carouselCollectionView.frame.height
        let cellPadding = (frame.width - collectionViewCellWidth) / 2
        print("Configure view frame.width : \(frame.width)")
        print("cellPadding : \(cellPadding)")
        
        let carouselLayout = UICollectionViewFlowLayout()
        carouselLayout.scrollDirection = .horizontal
        carouselLayout.itemSize = .init(width: collectionViewCellWidth, height: collectionViewCellHeight)
        carouselLayout.sectionInset = .init(top: 0, left: cellPadding, bottom: 0, right: cellPadding)
        carouselLayout.minimumLineSpacing = cellPadding * 2
        carouselCollectionView.collectionViewLayout = carouselLayout
        carouselData = data
        carouselCollectionView.reloadData()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
}

// MARK: - Helpers

private extension CarouselView {
    func getCurrentPage() -> Int {
        
        let visibleRect = CGRect(origin: carouselCollectionView.contentOffset, size: carouselCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = carouselCollectionView.indexPathForItem(at: visiblePoint) {
            return visibleIndexPath.row
        }
        
        return currentPage
    }
}

