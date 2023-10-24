//
//  FrameworkGridViewModel.swift
//  Apple-Frameworks
//
//  Created by Madhumitha Loganathan on 10/09/23.
//

import Foundation


final class FrameworkGridViewModel :ObservableObject {
    
    var selectedFramework : Framework? {
        didSet {
            isShowingDetailview = true
        }
    }
    @Published var isShowingDetailview = false
}
