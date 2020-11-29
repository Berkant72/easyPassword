//
//  LaunchView.swift
//  EasyPassword
//
//  Created by Berkant Dursun on 22.11.20.
//

import SwiftUI

struct LaunchView: View {
    
    // MARK: - PROPERTIES
   
    // MARK: - BODY
    
    var body: some View {
    
            Text("Hello SwiftUI")
    }
}

// MARK: - PREVIEW
struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
            .previewLayout(.fixed(width: 300, height: 250))
    }
}
