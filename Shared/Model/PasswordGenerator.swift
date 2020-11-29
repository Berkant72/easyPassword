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
    @Published var isSpecial: Bool = true
    @Published var password: String = ""
    @Published var characters: [String] = ["easyPassword+"]
    
//    let allCharacters = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","0","1","2","3","4","5","6","7","8","9","@","!","§","$","%","&","/","(",")","?"]
    
    let letters = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    let numbers = ["0","1","2","3","4","5","6","7","8","9"]
    let specials = ["@","!","§","$","%","&","/","(",")","?"]
    
    
    
    func generatePassword(_ from: [String], with length: Int) {
        characters = [""]
        
        switch true {
        case isLetter && isNumber && isSpecial:
            print("isletter and isNumber and isSpecial")
            characters = letters + numbers + specials
        case isLetter && isNumber:
            print("isLetter and isNumber")
            characters = letters + numbers
        case isNumber && isSpecial:
            print("isNumber and isSpecial")
            characters = numbers + specials
        case isLetter && isSpecial:
            print("isLetter an isSpecial")
            characters = letters + specials
        case isLetter:
            print("isLetter")
            characters.append(contentsOf: letters)
        case isNumber:
            print("isNumber")
            characters.append(contentsOf: numbers)
        case isSpecial:
            print("isSpecial")
            characters.append(contentsOf: specials)
        default:
            characters = [""]
        }
        
        for _ in 0..<length {
            password.append(characters.randomElement()!)
        }
        //        return password
    }
}
