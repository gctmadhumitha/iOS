//
//  Utilities.swift
//  iQuest
//
//  Created by Madhumitha Loganathan on 01/09/23.
//

import Foundation
import UIKit

extension UIColor {
    static var random: UIColor {
            let redValue = CGFloat(drand48())
            let greenValue = CGFloat(drand48())
            let blueValue = CGFloat(drand48())
                
            let randomColor = UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0)
                
            return randomColor
    }
}
