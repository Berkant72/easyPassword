//
//  HeaderView.swift
//  EasyPassword
//
//  Created by Berkant Dursun on 28.11.20.
//

import SwiftUI

struct HeaderView: View {
    // MARK: - PROPERTIES
    
    @State private var keyLength: Int = 25
    @State private var animateTitle: Bool = false
    
    let title = "easyPassword+"
    
    // MARK: - BODY
    
    var body: some View {
    
            VStack {
                
                Image(systemName: "key")
                    .font(.system(size: 60))
                    .shadow(color: .gray, radius: 2, x: 4.0, y: 4.0)
                    .scaleEffect(CGSize(width: animateTitle ? 1.5 : 0.2, height: animateTitle ? 1.5 : 0.2))
                    .animation(Animation.easeIn.speed(0.5))
                
                
                Text("\(title)")
                    .font(.headline)
                    .shadow(color: .gray, radius: 2, x: 4.0, y: 4.0)
                    .offset(x: 0, y: animateTitle ? 40 : 0)
                    .scaleEffect(CGSize(width: animateTitle ? 1.5 : 0.2, height: animateTitle ? 1.5 : 0.2))
                    .animation(Animation.easeIn.speed(0.5))
                
                
                
            } //: VSTACK
//            .frame(width: 300, height: 250, alignment: .center)
            .onAppear(perform: {
                animateTitle = true
            })
            .onDisappear(perform: {
                animateTitle = false
            })

    }
}

// MARK: - PREVIEW

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}
