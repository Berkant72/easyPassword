//
//  ContentView.swift
//  Shared
//
//  Created by Berkant Dursun on 22.11.20.
//

import SwiftUI
import MobileCoreServices

//enum PasswordType: String, CaseIterable, Identifiable {
//    case random
//    case pin
//
//    var id: String { self.rawValue }
//}
struct ContentView: View {
    
    // MARK: - PROPERTIES
    
    @State private var sliderValueRandom = 8.0
    @State private var sliderValuePin = 6.0
    @State private var sliderMinValue = 6.0
    @State private var sliderMaxValue = 50.0
    @State private var showingInfoView: Bool = false
    @State private var showToggles: Bool = true
    @StateObject var passwordGenerator = PasswordGenerator()
    
    let pasteboard = UIPasteboard.general
    
    var slideInAnimation: Animation {
        Animation.spring(response: 1.5, dampingFraction: 0.5, blendDuration: 0.5)
            .speed(1)
            .delay(0.25)
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
                    
                    
                    Text("\(passwordGenerator.isRandom ? passwordGenerator.password : passwordGenerator.pin)")
                        .font(.title2)
                        .lineLimit(0)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 8)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(passwordGenerator.getStrengthColor(for: Int(passwordGenerator.isRandom ? sliderValueRandom : sliderValuePin)), lineWidth: 2))
                    
                    
                    // MARK: - TOGGLE PASSWORDTYPE
                    
                    HStack {
                        
                        Button("Random", action: {
                            sliderValueRandom = 8
                            sliderMinValue = 6
                            sliderMaxValue = 50
                            passwordGenerator.password = ""
//                            passwordGenerator.generatePassword(with: Int(passwordGenerator.isRandom ? sliderValueRandom : sliderValuePin))
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
                            sliderValuePin = 6
                            sliderMinValue = 3
                            sliderMaxValue = 20
                            passwordGenerator.pin = ""
//                            passwordGenerator.generatePassword(with: Int(passwordGenerator.isRandom ? sliderValueRandom : sliderValuePin))
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
                        Text("Länge: \(Int(passwordGenerator.isRandom ? sliderValueRandom : sliderValuePin))")
                            .font(.body)
                    
                        Slider(value: passwordGenerator.isRandom ? $sliderValueRandom : $sliderValuePin, in: sliderMinValue ... sliderMaxValue, step: 1, onEditingChanged: { ( value ) in

                            if value == false {
                                passwordGenerator.password = ""
                                passwordGenerator.pin = ""
                                passwordGenerator.generatePassword(with: Int(passwordGenerator.isRandom ? sliderValueRandom : sliderValuePin))

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
                        
                        // COPY BUTTON
                        
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
                        
                        // REFRESH BUTTON
                        
                        Button(action: {
                            passwordGenerator.password = ""
                            passwordGenerator.generatePassword(with: Int(passwordGenerator.isRandom ? sliderValueRandom : sliderValuePin))
                            
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
            passwordGenerator.isRandom = true
            passwordGenerator.generatePassword(with: Int(passwordGenerator.isRandom ? sliderValueRandom : sliderValuePin))
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
