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
    let specials = "@!§$%&/()?,.-_;:?"
    
    // TODO: Show PIN only digits
    
    func generatePin(_ from: String, with length: Int) {
        for _ in 0..<length {
            password.append(numbers.randomElement() ?? "-")
        }
    }
    
    func generatePassword(_ from: String, with length: Int) {
        characters = ""
        
        switch true {
        case isLetter && isNumber && isSymbol:
            print("isletter and isNumber and isSpecial")
            characters.append(letters)
            characters.append(numbers)
            characters.append(specials)
        case isLetter && isNumber:
            print("isLetter and isNumber")
            characters.append(letters)
            characters.append(numbers)
        case isNumber && isSymbol:
            print("isNumber and isSpecial")
            characters.append(numbers)
            characters.append(specials)
        case isLetter && isSymbol:
            print("isLetter an isSpecial")
            characters.append(letters)
            characters.append(specials)
        case isLetter:
            print("isLetter")
            characters.append(letters)
        case isNumber:
            print("isNumber")
            characters.append(numbers)
        case isSymbol:
            print("isSpecial")
            characters.append(specials)
        default:
            characters = ""
        }
        
        for _ in 0..<length {
            password.append(characters.randomElement() ?? "-")
        }
        //        return password
    }
}