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
    static let tertiaryTextColor = UIColor.white
//
//    //Views
    static let primaryBackground =  UIColor.systemBackground
    static let secondaryBackground = UIColor.systemBackground
    static let primaryAppColor = gradientColor1!
    static let secondaryAppColor = gradientColor2!
//    static let lightGray = UIColor(hex: "#f2f2f2ff")
//
//    //Button
//    static let primaryButtonColor = UIColor(named:"buttonColor")
//    static let secondaryButtonColor = UIColor.systemGray5
    static let appTitleColor = UIColor.white
    static let buttonTextColor = UIColor(named: "buttonTextColor")
//    static let secondaryButtonTextColor = UIColor(named: "#7c2ae6ff") //7c2ae6
    
    static let gradientColor1 = UIColor(hex: "#27B7D1ff")
    static let gradientColor2 = UIColor(hex: "#5e51f2ff") //(hex: "#7055e1ff")
    static let yellowColor = UIColor(hex: "#fdc921ff")
    static let redColor = UIColor(hex: "#e34f74ff")
    
    //Other
    static let shadowColor =  UIColor(hex: "#f2f2f2ff")
}

enum AppFonts {
    static let buttonFont = UIFont.preferredFont(forTextStyle: .title3)
    static let titleFont = UIFont(name: "Cream Cake", size: 56)
    static let subtitleFont = UIFont(name: "Cream Cake", size: 40)
}

enum AppConstants {
    static let buttonWidth = CGFloat(40)
    static let buttonCornerRadius = CGFloat(10)
}
