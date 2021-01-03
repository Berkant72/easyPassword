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


/*
 // Stepper value couldn't update password generator
 
 Stepper(value: $numbersValue, in: 0...3, step: 1) { _ in
     passwordGenerator.numbersCount = numbersValue
     passwordGenerator.generateNewValues()
 } label: {
     Text("Zahlen ( max. \(passwordGenerator.numbersCount) )")
 }

 Stepper(value: $symbolsValue, in: 0...3, step: 1) { _ in
     passwordGenerator.symbolsCount = symbolsValue
     passwordGenerator.generateNewValues()
 } label: {
     Text("Symbole ( max. \(passwordGenerator.symbolsCount) )")
 }
*/
