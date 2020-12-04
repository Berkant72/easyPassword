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
    @Published var characters: String = "easyPassword+"
    
//    let allCharacters = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","0","1","2","3","4","5","6","7","8","9","@","!","§","$","%","&","/","(",")","?"]
    
//    let letters = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
//    let numbers = ["0","1","2","3","4","5","6","7","8","9"]
//    let specials = ["@","!","§","$","%","&","/","(",")","?",",",".","-","_",";",":","?"]
    
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    let numbers = "0123456789"
    let symbols = "@!§$%&/()?,.-_;:?"
    
    // TODO: Show PIN only digits
    
    func generatePin(_ from: String, with length: Int) {
        for _ in 0..<length {
            password.append(numbers.randomElement() ?? "-")
        }
    }
    
    func generatePassword(_ from: String, with length: Int) {
        characters = ""
        switch true {
        case isNumber && isSymbol:
            characters.append(letters)
            characters.append(numbers)
            characters.append(symbols)
        case isNumber:
            characters.append(letters)
            characters.append(numbers)
        case isSymbol:
            characters.append(letters)
            characters.append(symbols)
        default:
            characters.append(letters)
        }
        
        for _ in 0..<length {
            password.append(characters.randomElement() ?? "-")
        }
        //        return password
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
