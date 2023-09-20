//
//  FrameworkDetailView.swift
//  Apple-Frameworks
//
//  Created by Madhumitha Loganathan on 08/09/23.
//

import SwiftUI

struct FrameworkDetailView: View {
    let framework : Framework
    @Binding var isShowingDetailView: Bool
    @State private var isShowingSafariView = false
    
    var body: some View {
        VStack{
            XDismissButton(isShowingModal: $isShowingDetailView)
            Spacer()
            FrameworkItemView(framework: framework)
            Text(framework.description)
                .font(.body)
                .padding()
            Spacer()
            Button {
                isShowingSafariView = true
            } label :{
                AFButton(title: "Learn More")
            }
        }.sheet(isPresented: $isShowingSafariView,  content: {
            let url = URL(string: framework.urlString) ?? URL(string:"www.apple.com")!
            SafariView(url:url)
            }
        )
    }
}

struct FrameworkDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FrameworkDetailView(framework: MockData.sampleFramework, isShowingDetailView: .constant(false))
    }
}
