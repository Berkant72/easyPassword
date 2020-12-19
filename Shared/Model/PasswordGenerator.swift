//
//  PasswordGenerator.swift
//  EasyPassword (iOS)
//
//  Created by Berkant Dursun on 29.11.20.
//

import SwiftUI

enum PasswordQuality: String {
    case sehrSchwach = "sehr schwach"
    case schwach = "schwach"
    case mittelmaeßig = "mittelmäßig"
    case stark = "stark"
    case sehrStark = "sehr stark"
}


class PasswordGenerator: ObservableObject {
    
    @Published var isLetter: Bool = true
    @Published var isNumber: Bool = true
    @Published var isSymbol: Bool = true
    @Published var isPassword: Bool = false
    @Published var isPin: Bool = false
    @Published var password: String = ""
    @Published var pin: String = ""
    @Published var lastPassword = ""
    @Published var lastPin = ""
    @Published var sliderValueRandom = 8.0
    @Published var sliderValuePin = 4.0
    @Published var passwordQuality = PasswordQuality.stark
    
    
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    let numbers = "0123456789"
    let symbols = "@!§$%&+-/*()?,._;:?=#<>"
    
    //    let allCharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@!§$%&+-/*()?,._;:?=#<>"
    //    let allCharactersArray = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","0","1","2","3","4","5","6","7","8","9","@","!","§","$","%","&","+","-","/","*","(",")","?",",",".","_",";",":","?","=","#","<",">"]
    
    func generateNewValues() {
        password = ""
        pin = ""
        generatePassword(with: Int(isPassword ? sliderValueRandom : sliderValuePin))
        passwordQuality = getPasswordQuality()
        lastPin = pin
        lastPassword = password
    }
    
    func generatePassword(with length: Int) {
        
        var tempString = ""
        
        if isPin {
            for _ in 0..<length {
                pin.append(numbers.randomElement() ?? " ")
            }
            
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
            password.append(tempString.randomElement() ?? " ")
        }
    }
    
    
    func getPasswordQuality() -> PasswordQuality {
        //        let passwordQuality = PasswordQuality.schwach
        
        
        if isPassword && isNumber && isSymbol {
            switch sliderValueRandom {
            case 0...5:
                return .sehrSchwach
            case 6...6:
                return .schwach
            case 7...7:
                return .mittelmaeßig
            case 8...8:
                return .stark
            case 9...50:
                return .sehrStark
            default:
                return .sehrSchwach
            }
        } else if isPassword && (isNumber || isSymbol) {
            switch sliderValueRandom {
            case 0...6:
                return .sehrSchwach
            case 7...7:
                return .schwach
            case 8...8:
                return .mittelmaeßig
            case 9...9:
                return .stark
            case 10...50:
                return .sehrStark
            default:
                return .sehrSchwach
            }
        } else if isPassword {
            switch sliderValueRandom {
            case 0...6:
                return .sehrSchwach
            case 7...8:
                return .schwach
            case 9...9:
                return .mittelmaeßig
            case 10...10:
                return .stark
            case 11...50:
                return .sehrStark
            default:
                return .sehrSchwach
            }
        }
        
        if isPin {
            switch sliderValuePin {
            case 0...10:
                return .sehrSchwach
            case 11...11:
                return .schwach
            case 12...20:
                return .mittelmaeßig
            default:
                return .sehrSchwach
            }
        }
        
        return .mittelmaeßig
    }
    
    func getStrengthColor(for passwordQuality: PasswordQuality) -> Color {
        
        switch passwordQuality {
        case .sehrSchwach:
            print("sehr schwach")
            return .red
        case .schwach:
            print("schwach")
            return Color.red.opacity(0.5)
        case .mittelmaeßig:
            print("mittelmäßig")
            return Color.orange.opacity(0.5)
        case .stark:
            print("stark")
            return Color.green.opacity(0.6)
        case .sehrStark:
            print("sehr stark")
            return .green
        }
    }
    
}
