//
//  FrameworkItemView.swift
//  Apple-Frameworks
//
//  Created by Madhumitha Loganathan on 10/09/23.
//

import SwiftUI


struct FrameworkItemView: View {
    
    let framework: Framework
    var body: some View {
        VStack {
            Image(framework.imageName)
                .resizable()
                .frame(width: 90, height: 90)
            Text(framework.name)
                .font(.title2)
                .fontWeight(.semibold)
                .scaledToFit()
                .minimumScaleFactor(0.5)
        }
        .padding()
    }
}


struct FrameworkItemView_Previews: PreviewProvider {
    static var previews: some View {
        FrameworkItemView(framework: MockData.sampleFramework)
    }
}
