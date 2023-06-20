//
//  PasswordGenerator.swift
//  EasyPassword (iOS)
//
//  Created by Berkant Dursun on 29.11.20.
//

import SwiftUI

enum PasswordQuality: String {
    case veryWeak = "very weak"
    case toWeak = "weak"
    case medium = "medium"
    case strong = "strong"
    case veryStrong = "very strong"
}


class PasswordGenerator: ObservableObject {
    
    @Published var isNumber: Bool = true
    @Published var isSymbol: Bool = true
    @Published var password: String = ""
    @Published var pin: String = ""
    @Published var lastPassword = ""
    @Published var lastPin = ""
    @Published var sliderValueRandom = 12.0
    @Published var sliderValuePin = 6.0
    @Published var passwordQuality = PasswordQuality.strong
    @Published var pickerSelection: Int = 1
    @Published var showToggles: Bool = true
    
    var sliderMinValue = 1.0
    var sliderMaxValue = 64.0
    
    let lettersArray = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    let numbersArray = ["0","1","2","3","4","5","6","7","8","9"]
    let symbolsArray = ["{","[","(","<","@","!","§","$","%","&","+","-","/","*","?",",",".","_",";",":","=","#",">",")","]","}"]
    
    
    func generateNewValues() {
        password = ""
        pin = ""
        generatePassword(with: Int(pickerSelection == 1 ? sliderValueRandom : sliderValuePin))
        passwordQuality = getPasswordQuality()
        lastPin = pin
        lastPassword = password
    }
    
    func generatePassword(with length: Int) {
        
        getSliderMinAndMaxValue()
        var tempArray = [""]
        
        switch pickerSelection {
        case 1:
            showToggles = true
            lastPassword = password
            
            switch true {
            case isNumber && isSymbol:
                tempArray.append(contentsOf: lettersArray)
                tempArray.append(contentsOf: numbersArray)
                tempArray.append(contentsOf: symbolsArray)
            case isNumber:
                tempArray.append(contentsOf: lettersArray)
                tempArray.append(contentsOf: numbersArray)
            case isSymbol:
                tempArray.append(contentsOf: lettersArray)
                tempArray.append(contentsOf: symbolsArray)
            default:
                tempArray.append(contentsOf: lettersArray)
            }
        case 2:
            showToggles = false
            lastPin = pin
            
            for _ in 0..<length {
                pin.append(numbersArray.randomElement() ?? " ")
            }
        default:
            break
        }
        
        
        for _ in 0..<length {
            password.append(tempArray.randomElement() ?? " ")
        }
    }
    
    func getSliderMinAndMaxValue() {
        if pickerSelection == 1 {
            sliderMinValue = 6
            sliderMaxValue = 64
        } else {
            sliderMinValue = 3
            sliderMaxValue = 12
        }
    }
    
    func getPasswordQuality() -> PasswordQuality {
        
        if pickerSelection == 1 && isNumber && isSymbol {
            switch sliderValueRandom {
            case 0...5:
                return .veryWeak
            case 6...6:
                return .toWeak
            case 7...7:
                return .medium
            case 8...12:
                return .strong
            default:
                return .veryStrong
            }
        } else if pickerSelection == 1 && (isNumber || isSymbol) {
            switch sliderValueRandom {
            case 0...6:
                return .veryWeak
            case 7...8:
                return .toWeak
            case 9...12:
                return .medium
            case 13...15:
                return .strong
            default:
                return .veryStrong
            }
        } else if pickerSelection == 1 {
            switch sliderValueRandom {
            case 0...6:
                return .veryWeak
            case 7...9:
                return .toWeak
            case 10...13:
                return .medium
            case 14...18:
                return .strong
            default:
                return .veryStrong
            }
        }
        
        if pickerSelection == 2 {
            switch sliderValuePin {
            case 0...6:
                return .veryWeak
            case 7...11:
                return .toWeak
            default:
                return .medium
            }
        }
        
        return .medium
    }
    
    func getStrengthColor(for passwordQuality: PasswordQuality) -> Color {
        
        switch passwordQuality {
        case .veryWeak:
            return Color.red
        case .toWeak:
            return Color.red.opacity(0.5)
        case .medium:
            return Color.orange.opacity(0.6)
        case .strong:
            return Color.green.opacity(0.4)
        case .veryStrong:
            return Color.green
        }
    }
    
}
