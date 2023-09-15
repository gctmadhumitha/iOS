//
//  Constants.swift
//  iQuest
//
//  Created by Madhumitha Loganathan on 11/09/23.
//

import Foundation
import UIKit    

enum AppColors {
    static let accentColor = UIColor.black
    
    //Text
    static let headerTextColor = UIColor(named: "headerTextColor")
    static let primaryTextColor = UIColor(named: "primaryTextColor")
    static let secondaryTextColor = UIColor.systemGray

    //Views
    static let primaryBackground = UIColor.systemBackground
    static let secondaryBackground = UIColor(named: "background")
    static let primaryAppColor = UIColor(named: "primaryAppColor") ?? UIColor.systemMint
    static let secondaryAppColor = UIColor(named: "secondaryAppColor")
    static let lightGray = UIColor(hex: "#f2f2f2ff")
    
    //Button
    static let buttonColor = primaryAppColor
    static let buttonTextColor = UIColor(named: "buttonTextColor")
    
    //Other
    static let shadowColor = lightGray
}

enum AppFonts {
    static let buttonFont = UIFont.preferredFont(forTextStyle: .title3)
}

enum Constants {
    static let buttonWidth = CGFloat(40)
    static let buttonCornerRadius = 20
}
