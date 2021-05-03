//
//  Modifiers.swift
//  EasyPassword (iOS)
//
//  Created by Berkant Dursun on 30.01.21.
//

import SwiftUI

struct passwordTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title2)
            .multilineTextAlignment(.leading)
            .lineLimit(nil)
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            
    }
   
}
