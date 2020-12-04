//
//  ContentView.swift
//  Shared
//
//  Created by Berkant Dursun on 22.11.20.
//

import SwiftUI
import MobileCoreServices

enum PasswordType: String, CaseIterable, Identifiable {
    case random
    case pin
    
    var id: String { self.rawValue }
}
struct ContentView: View {
    
    // MARK: - PROPERTIES
    
    @State private var sliderValue = 6.0
    @State private var sliderMinValue = 3.0
    @State private var sliderMaxValue = 20.0
    @State private var showingInfoView: Bool = false
    @State private var passwordType: PasswordType = .random
    @State private var showToggles: Bool = true
//    @State private var isActivePicker: Bool = true
    @State private var colorStrength: Color = Color.red
    @StateObject var passwordGenerator = PasswordGenerator()
    
    let pasteboard = UIPasteboard.general
    
        var slideInAnimation: Animation {
    
            Animation.spring(response: 1.5, dampingFraction: 0.5, blendDuration: 0.5)
                .speed(1)
                .delay(0.25)
        }
    
    func getStrengthColor(for length: Int) -> Color {
        if passwordGenerator.isPin {
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
    
    // MARK: - BODY
    
    var body: some View {
        
        GeometryReader { geoReader in
            VStack(alignment: .center, spacing: 20) {
                
                // MARK: - Header
                
                HeaderView()
                    .frame(width: geoReader.size.width, height: geoReader.size.height / 4, alignment: .center)
                    .position(CGPoint(x: geoReader.frame(in: .global).midX, y: geoReader.frame(in: .global).minX + 100))
                
                
                Spacer()
                
                // MARK: - PASSWORD GENERATOR
                
                VStack(alignment: .center, spacing: 20) {
                    
                    // MARK: - NEW PASSWORD
                    
                    
                    Text("\(passwordGenerator.password)")
                        .font(.title2)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 8)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(getStrengthColor(for: Int(sliderValue)), lineWidth: 2))
                    
                    
                    // MARK: - TOGGLE CHARACTERS
                    
                    HStack {
                        
                        Button("Random", action: {
                            sliderValue = 8
                            sliderMinValue = 6
                            sliderMaxValue = 50
                            passwordGenerator.password = ""
                            passwordGenerator.generatePassword(passwordGenerator.characters, with: Int(sliderValue))
                            showToggles = true
                            passwordGenerator.isRandom = true
                            passwordGenerator.isPin = false
                            
                        })
                        .font(.title2)
                        .frame(width: 100, height: 32, alignment: .center)
                        .background(passwordGenerator.isRandom ? Color.gray : Color.clear)
                        .foregroundColor(passwordGenerator.isRandom ? .black : .gray)
                        .clipShape(Capsule())
                        
                        
                        Spacer()
                        
                        
                        Button("PIN", action: {
                            sliderValue = 6
                            sliderMinValue = 3
                            sliderMaxValue = 20
                            passwordGenerator.password = ""
                            passwordGenerator.generatePin(passwordGenerator.characters, with: Int(sliderValue))
                            
                            showToggles = false
                            passwordGenerator.isRandom = false
                            passwordGenerator.isPin = true
                        })
                        .font(.title2)
                        .frame(width: 100, height: 32, alignment: .center)
                        .background(passwordGenerator.isPin ? Color.gray : Color.clear)
                        .foregroundColor(passwordGenerator.isPin ? .black : .gray)
                        .clipShape(Capsule())
                    }
                    
                    .frame(width: 200, height: 40)
                    .padding(.horizontal, 8)
                    .background(Color.gray.opacity(0.5))
                    .clipShape(Capsule())
                    .animation(slideInAnimation)
                    
         
                    
                    // MARK: - CHANGE PASSWORD LENGTH
                    
                    HStack {
                        Text("Länge: \(Int(sliderValue))")
                            .font(.body)
                        
                        Slider(value: $sliderValue, in: sliderMinValue ... sliderMaxValue, step: 1, onEditingChanged: { ( value ) in
                            // code
                            if value == false {
                                passwordGenerator.password = ""
                                if passwordGenerator.isRandom {            passwordGenerator.generatePassword(passwordGenerator.characters, with: Int(sliderValue))
                                    //            password = "easyPassword+"
                                } else {
                                    passwordGenerator.generatePin(passwordGenerator.characters, with: Int(sliderValue))
                                }
                                
                            }
                        })
                        .padding(.horizontal, 20)
                        .accentColor(.blue)
                    }
                    
                    
                    // MARK: - TOGGLES NUMBERS AND SYMBOLS
                    
                    if showToggles {
                        VStack {
                            Toggle("Zahlen", isOn: $passwordGenerator.isNumber)
                                .toggleStyle(SwitchToggleStyle(tint: Color.blue))
                            Toggle("Symbole", isOn: $passwordGenerator.isSymbol)
                                .toggleStyle(SwitchToggleStyle(tint: Color.blue))
                            
                        } //: VSTACK
                        
                    } else {
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: 70)
                    }
                    
                    
                    
                    
                    // MARK: - COPY PASSWORD OR REFRESH PASSWORD
                    
                    HStack {
                        Button(action: {
                            pasteboard.string = passwordGenerator.password
                            
                            // UIPasteboard.general.setValue("\(String(describing: password))", forPasteboardType: kUTTypePlainText as String)
                            
                            
                        }, label: {
                            Image(systemName: "doc.on.doc")
                                .font(.system(size: 32))
                                .accentColor(.blue)
                            
                        })
                        .accentColor(.blue)
                        .padding(.horizontal, 20)
                        
                        Spacer()
                            .frame(maxWidth: 300.0)
                        
                        Button(action: {
                            
                            if passwordGenerator.isRandom {
                                passwordGenerator.password = ""
                                passwordGenerator.generatePassword(passwordGenerator.characters, with: Int(sliderValue))
                                //            password = "easyPassword+"
                            } else {
                                passwordGenerator.password = ""
                                passwordGenerator.generatePin(passwordGenerator.characters, with: Int(sliderValue))
                            }
                            
                        }, label: {
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 32))
                                .accentColor(.blue)
                        })
                        
                    }
                    .padding(.horizontal, 50)
                    
                } //: VSTACK
                .padding(.bottom, 50)
            } //: VSTACK
            .overlay(
                // INFO
                Button(action: {
                    showingInfoView = true
                }, label: {
                    Image(systemName: "info.circle")
                })
                .accentColor(.blue)
                .font(.title),
                alignment: .topTrailing
            )
            .padding(.top, 50)
            .padding(.horizontal, 16)
            
        } //: GEOMETRYREADER
        .edgesIgnoringSafeArea(.all)
        .onAppear(perform: {
            if passwordGenerator.isRandom {            passwordGenerator.generatePassword(passwordGenerator.characters, with: Int(sliderValue))
                //            password = "easyPassword+"
            } else {
                passwordGenerator.generatePin(passwordGenerator.characters, with: Int(sliderValue))
            }
            
        })
        
        .sheet(isPresented: $showingInfoView) {
            InfoView()
        }
    }
    
}

//struct PasswordSegmentView: View {
//
////    @StateObject var pwGenarator = PasswordGenerator()
//    @Binding var sliderValue: Double
//    @Binding var sliderMin:Double
//    @Binding var sliderMax: Double
//    @Binding var showToggles: Bool
//    @Binding var passwordGenerator: PasswordGenerator
//
//    var slideInAnimation: Animation {
//
//        Animation.spring(response: 1.5, dampingFraction: 0.5, blendDuration: 0.5)
//            .speed(1)
//            .delay(0.25)
//    }
//
//    var body: some View {
//
//
//        HStack {
//
//            Button("Random", action: {
//                sliderValue = 8
//                sliderMin = 6
//                sliderMax = 50
//                pwGenarator.password = "asdfsa"
//                pwGenarator.generatePassword(pwGenarator.characters, with: Int(sliderValue))
//                showToggles = true
//                pwGenarator.isRandom = true
//                pwGenarator.isPin = false
//
//            })
//            .font(.title2)
//            .frame(width: 100, height: 32, alignment: .center)
//            .background(passwordGenerator.isRandom ? Color.gray : Color.clear)
//            .foregroundColor(passwordGenerator.isRandom ? .black : .gray)
//            .clipShape(Capsule())
//
//
//            Spacer()
//
//
//            Button("PIN", action: {
//                sliderValue = 6
//                sliderMin = 3
//                sliderMax = 20
//                pwGenarator.password = "11111"
//                pwGenarator.generatePin(pwGenarator.characters, with: Int(sliderValue))
//
//                showToggles = false
//                pwGenarator.isRandom = false
//                pwGenarator.isPin = true
//            })
//            .font(.title2)
//            .frame(width: 100, height: 32, alignment: .center)
//            .background(pwGenarator.isPin ? Color.gray : Color.clear)
//            .foregroundColor(pwGenarator.isPin ? .black : .gray)
//            .clipShape(Capsule())
//        }
//
//        .frame(width: 200, height: 40)
//        .padding(.horizontal, 8)
//        .background(Color.gray.opacity(0.5))
//        .clipShape(Capsule())
//        .animation(slideInAnimation)
//    }
//}




// MARK: - PREVIEW

struct ContentView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
        ContentView()
            .preferredColorScheme(.dark)
    }
}
