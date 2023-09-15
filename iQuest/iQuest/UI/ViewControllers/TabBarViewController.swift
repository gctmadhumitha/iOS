
//
//  ListViewController.swift
//  iQuest
//
//  Created by Madhumitha Loganathan on 01/09/23.
//

import UIKit
import SwiftUI

final class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupTabs()
       // setUpTabs()
    }
    
    private func setupTabs(){
        
        //self.view.backgroundColor = .systemBackground
        self.tabBar.tintColor = AppColors.primaryAppColor
        self.tabBar.backgroundColor = AppColors.secondaryBackground
        self.navigationController?.isNavigationBarHidden = true
      
        let tab1ViewController = UINavigationController(rootViewController: QuizCategoriesViewController())
        let tabItem1 = UITabBarItem(title: "Trivia", image: UIImage(systemName:  "circle"),
                                    selectedImage: UIImage(systemName: "circle.fill"))
        tab1ViewController.tabBarItem = tabItem1
        
        let tab2ViewController  = FactsViewController()
        let tabItem2 = UITabBarItem(title: "Facts", image: UIImage(systemName:  "square"),selectedImage: UIImage(systemName: "square.fill"))
        tab2ViewController.tabBarItem = tabItem2
        
        let tab3ViewController  = UIHostingController(rootView:ChatView())
        let tabItem3 = UITabBarItem(title: "Chat GPT", image: UIImage(systemName:  "heart"),selectedImage: UIImage(systemName: "heart.fill"))
        tab3ViewController.tabBarItem = tabItem3
        
        let tab4ViewController  = SettingsViewController()
        let tabItem4 = UITabBarItem(title: "Settings", image: UIImage(systemName:  "heart"),selectedImage: UIImage(systemName: "triangle.fill"))
        tab4ViewController.tabBarItem = tabItem4
        
        self.viewControllers = [tab1ViewController, tab2ViewController, tab3ViewController, tab4ViewController]
        
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("tab bar printed", item.title ?? "nil")
    }
    
}
