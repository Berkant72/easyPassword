//
//  PasswordGenerator.swift
//  EasyPassword (iOS)
//
//  Created by Berkant Dursun on 29.11.20.
//

import SwiftUI

enum PasswordQuality: String {
    case veryWeak = "sehr schwach"
    case weak = "schwach"
    case medium = "mittelmäßig"
    case strong = "stark"
    case veryStrong = "sehr stark"
}


class PasswordGenerator: ObservableObject {
    
    @Published var isNumber: Bool = true
    @Published var isSymbol: Bool = true
    @Published var password: String = ""
    @Published var pin: String = ""
    @Published var lastPassword = ""
    @Published var lastPin = ""
    @Published var sliderValueRandom = 8.0
    @Published var sliderValuePin = 4.0
    @Published var passwordQuality = PasswordQuality.strong
    @Published var pickerSelection: Int = 1
    @Published var sliderMinValue = 6.0
    @Published var sliderMaxValue = 32.0
    @Published var showToggles: Bool = true
    
//    var showToggles: Bool = true {
//        willSet {
//            objectWillChange.send()
//        }
//    }
    
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    let numbers = "0123456789"
    let symbols = "{[(<@!§$%&+-/*?,._;:?=#>)]}"
    
    //    let allCharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789{[(<@!§$%&+-/*?,._;:?=#>)]}"
    //    let allCharactersArray = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","0","1","2","3","4","5","6","7","8","9","@","!","§","$","%","&","+","-","/","*","(",")","?",",",".","_",";",":","?","=","#","<",">"]
    
    func generateNewValues() {
        password = ""
        pin = ""
        generatePassword(with: Int(pickerSelection == 1 ? sliderValueRandom : sliderValuePin))
        passwordQuality = getPasswordQuality()
        lastPin = pin
        lastPassword = password
    }
    
    func generatePassword(with length: Int) {
        
        setSliderValue()
        var tempString = ""
        
        switch pickerSelection {
        case 1:
            showToggles = true
            lastPassword = password
            
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
        case 2:
            showToggles = false
            lastPin = pin
            
            for _ in 0..<length {
                pin.append(numbers.randomElement() ?? " ")
            }
        default:
            break
        }
        
        
        for _ in 0..<length {
            password.append(tempString.randomElement() ?? " ")
        }
    }
    
    func setSliderValue() {
        if pickerSelection == 1 {
            sliderMinValue = 6
            sliderMaxValue = 32
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
                return .weak
            case 7...7:
                return .medium
            case 8...8:
                return .strong
            case 9...50:
                return .veryStrong
            default:
                return .veryWeak
            }
        } else if pickerSelection == 1 && (isNumber || isSymbol) {
            switch sliderValueRandom {
            case 0...6:
                return .veryWeak
            case 7...7:
                return .weak
            case 8...8:
                return .medium
            case 9...9:
                return .strong
            case 10...50:
                return .veryStrong
            default:
                return .veryWeak
            }
        } else if pickerSelection == 1 {
            switch sliderValueRandom {
            case 0...6:
                return .veryWeak
            case 7...8:
                return .weak
            case 9...9:
                return .medium
            case 10...10:
                return .strong
            case 11...50:
                return .veryStrong
            default:
                return .veryWeak
            }
        }
        
        if pickerSelection == 2 {
            switch sliderValuePin {
            case 0...10:
                return .veryWeak
            case 11...11:
                return .weak
            case 12...20:
                return .medium
            default:
                return .veryWeak
            }
        }
        
        return .medium
    }
    
    func getStrengthColor(for passwordQuality: PasswordQuality) -> Color {
        
        switch passwordQuality {
        case .veryWeak:
            return Color.red.opacity(0.8)
        case .weak:
            return Color.red.opacity(0.5)
        case .medium:
            return Color.orange.opacity(0.6)
        case .strong:
            return Color.green.opacity(0.4)
        case .veryStrong:
            return Color.green.opacity(0.9)
        }
    }
    
}
