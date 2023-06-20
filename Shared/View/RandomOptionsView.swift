//
//  RandomOptionsView.swift
//  EasyPassword
//
//  Created by Berkant Dursun on 19.12.20.
//

import SwiftUI

struct RandomOptionsView: View {

    @ObservedObject var passwordGenerator: PasswordGenerator
    
    
    var body: some View {
        VStack {
            Toggle("Numbers", isOn: $passwordGenerator.isNumber)
                .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                .onChange(of: passwordGenerator.isNumber, perform: { ( _ ) in
                    passwordGenerator.generateNewValues()
                })
            Toggle("Symbols", isOn: $passwordGenerator.isSymbol)
                .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                .onChange(of: passwordGenerator.isSymbol, perform: { ( _ ) in
                    passwordGenerator.generateNewValues()
                })
        }
//        .accentColor(Color.accentColor)
    }
}

struct RandomOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        RandomOptionsView(passwordGenerator: PasswordGenerator())
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
