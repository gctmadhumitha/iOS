//
//  SafariView.swift
//  Apple-Frameworks
//
//  Created by Madhumitha Loganathan on 10/09/23.
//

import Foundation
import SwiftUI
import SafariServices

struct SafariView : UIViewControllerRepresentable {
    
    let url: URL
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
        
    }
    
    
}
