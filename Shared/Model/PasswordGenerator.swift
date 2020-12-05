//
//  PasswordGenerator.swift
//  EasyPassword (iOS)
//
//  Created by Berkant Dursun on 29.11.20.
//

import SwiftUI

class PasswordGenerator: ObservableObject {
    
    @Published var isLetter: Bool = true
    @Published var isNumber: Bool = true
    @Published var isSymbol: Bool = true
    @Published var isRandom: Bool = true
    @Published var isPin: Bool = false
    @Published var password: String = ""
    @Published var pin: String = ""
    
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    let numbers = "0123456789"
    let symbols = "@!§$%&/()?,.-_;:?"
    

    
    func generatePassword(with length: Int) {
        
        var tempString = ""
        
        if isPin {
            tempString.append(numbers)
        } else {
            switch true {
            case isNumber && isSymbol:
                tempString.append(letters)
                tempString.append(numbers)
                tempString.append(symbols)
            case isNumber:
                tempString.append(letters)
                tempString.append(numbers)
            case isSymbol:
                tempString.append(letters)
                tempString.append(symbols)
            default:
                tempString.append(letters)
            }
        }
        
        for _ in 0..<length {
            password.append(tempString.randomElement() ?? "-")
        }
    }
    
    
    func getStrengthColor(for length: Int) -> Color {
        if isPin {
            print("pin")
            switch length {
            case 0...5:
                return Color.orange.opacity(0.5)
            case 6...8:
                return Color.green.opacity(0.6)
            case 9...11:
                return Color.green.opacity(0.6)
            default:
                return Color.green
            }
        } else {
            print("random")
            switch length {
            case 0...5:
                return Color.red.opacity(0.4)
            case 6...8:
                return Color.orange.opacity(0.5)
            case 9...11:
                return Color.green.opacity(0.6)
            default:
                return Color.green
                
            }
        }
    }
    
}
