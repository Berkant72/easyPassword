//
//  RandomOptionsView.swift
//  EasyPassword
//
//  Created by Berkant Dursun on 19.12.20.
//

import SwiftUI

struct RandomOptionsView: View {
    @Binding var numbers: Bool
    @Binding var symbols: Bool
    
    var body: some View {
        VStack {
            Toggle("Zahlen", isOn: $numbers)
                .toggleStyle(SwitchToggleStyle(tint: Color.blue))
            Toggle("Symbole", isOn: $symbols)
                .toggleStyle(SwitchToggleStyle(tint: Color.blue))
        }
    }
}

struct RandomOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        RandomOptionsView(numbers: .constant(true), symbols: .constant(true))
            .previewLayout(.sizeThatFits)
    }
}
