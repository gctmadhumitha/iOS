//
//  UIFont+extension.swift
//  PredictSpring
//
//  Created by Madhumitha Loganathan on 07/11/23.
//

import UIKit

extension UIFont {

    static var subheadline: UIFont {
        return UIFont.preferredFont(forTextStyle: .subheadline)
    }

    func with(weight: UIFont.Weight) -> UIFont {
        return UIFont.systemFont(ofSize: pointSize, weight: weight)
    }

}
