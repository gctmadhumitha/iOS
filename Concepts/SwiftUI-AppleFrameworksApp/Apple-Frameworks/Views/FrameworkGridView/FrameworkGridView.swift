//
//  FrameworkGridView.swift
//  Apple-Frameworks
//
//  Created by Madhumitha Loganathan on 08/09/23.
//

import SwiftUI

struct FrameworkGridView: View {
        
    @StateObject var viewModel = FrameworkGridViewModel()
    
    let coulmns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: coulmns) {
                    ForEach(MockData.frameworks) { framework in
                        FrameworkItemView(framework: framework)
                            .onTapGesture {
                                viewModel.selectedFramework = framework
                            }
                    }
                }
            }
            .navigationTitle("🍎 Frameworks")
            .fullScreenCover(isPresented:$viewModel.isShowingDetailview, content: {
                FrameworkDetailView(framework: viewModel.selectedFramework ?? MockData.sampleFramework, isShowingDetailView: $viewModel.isShowingDetailview)
            })
        }
        
    }
}

struct FrameworkGridView_Previews: PreviewProvider {
    static var previews: some View {
        FrameworkGridView()
    }
}


