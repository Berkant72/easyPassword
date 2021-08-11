//
//  HeaderView.swift
//  EasyPassword
//
//  Created by Berkant Dursun on 28.11.20.
//

import SwiftUI

struct HeaderView: View {
    // MARK: - PROPERTIES
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool =  false
    @State private var animateTitle: Bool = false
    
    let title = "easyPassword+"
    
    // MARK: - BODY
    
    var body: some View {
    
            VStack {
                
                Image(systemName: "lock.rectangle")
                    .foregroundColor(.orange)
                    .font(.system(size: 60))
                    .shadow(color: .orange.opacity(0.5), radius: 8, x: 4.0, y: 4.0)
                    .scaleEffect(CGSize(width: animateTitle ? 1.5 : 0.2, height: animateTitle ? 1.5 : 0.2))
                    .animation(Animation.easeIn.speed(0.4))
                
                
                Text("\(title)")
                    .foregroundColor(.orange)
                    .font(.headline)
                    .shadow(color: .orange.opacity(0.5), radius: 8, x: 4.0, y: 4.0)
                    .offset(x: 0, y: animateTitle ? 40 : 0)
                    .scaleEffect(CGSize(width: animateTitle ? 1.5 : 0.2, height: animateTitle ? 1.5 : 0.2))
                    .animation(Animation.easeIn.speed(0.4))
                
                
                
            } //: VSTACK
//            .frame(width: 300, height: 250, alignment: .center)
            .onAppear(perform: {
                animateTitle = true
            })
            .onDisappear(perform: {
                animateTitle = false
            })
            .preferredColorScheme(isDarkMode ? .dark : .light)

    }
}

// MARK: - PREVIEW

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}
