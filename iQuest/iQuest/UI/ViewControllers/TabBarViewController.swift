
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
        
        self.tabBar.tintColor = AppColors.primaryAppColor
        self.tabBar.backgroundColor = AppColors.secondaryBackground
        self.tabBar.barTintColor = AppColors.secondaryBackground
        self.navigationController?.isNavigationBarHidden = true
      
        let tab1ViewController = UINavigationController(rootViewController: QuizCategoriesViewController())
        let tabItem1 = UITabBarItem(title: "Quiz", image: UIImage(systemName:  "questionmark.folder"),
                                    selectedImage: UIImage(systemName: "questionmark.folder.fill"))
        tab1ViewController.tabBarItem = tabItem1
        
        let tab2ViewController  = FactsViewController()
        let tabItem2 = UITabBarItem(title: "Facts", image: UIImage(systemName:  "lightbulb"),selectedImage: UIImage(systemName: "lightbulb.fill"))
        tab2ViewController.tabBarItem = tabItem2
        
        let tab3ViewController  = UIHostingController(rootView:ChatView())
        let tabItem3 = UITabBarItem(title: "Chat GPT", image: UIImage(systemName:  "message.and.waveform"),selectedImage: UIImage(systemName: "message.and.waveform.fill"))
        tab3ViewController.tabBarItem = tabItem3
      
        self.viewControllers = [tab1ViewController, tab2ViewController, tab3ViewController]
        
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("tab bar printed", item.title ?? "nil")
    }
    
}
