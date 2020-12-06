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
    @State private var sliderMaxValue = 100.0
    @State private var showingInfoView: Bool = false
    @State private var showToggles: Bool = true
    @StateObject var passwordGenerator = PasswordGenerator()
    
    let pasteboard = UIPasteboard.general
    var textHeight: CGFloat {
        switch sliderValueRandom {
        case 0...19:
            return 40.0
        case 20...39:
            return 80.0
        case 40...59:
            return 120.0
        case 60...79:
            return 160.0
        case 80...100:
            return 200.0
        default:
            return 50.0
        }
        
    
    }
    
    var slideInAnimation: Animation {
        Animation.spring(response: 1.5, dampingFraction: 0.5, blendDuration: 0.5)
            .speed(1)
            .delay(0.25)
    }
    
    func generateNewValues() {
        passwordGenerator.password = ""
        passwordGenerator.pin = ""
        passwordGenerator.generatePassword(with: Int(passwordGenerator.isRandom ? sliderValueRandom : sliderValuePin))
    }

    
    // MARK: - BODY
    
    var body: some View {
        
        GeometryReader { geoReader in
            VStack(alignment: .center, spacing: 20) {
                
                // MARK: - Header
                
                HeaderView()
                    .frame(width: geoReader.size.width, height: geoReader.size.height / 4, alignment: .center)
                    .position(CGPoint(x: geoReader.frame(in: .global).midX - 20, y: geoReader.frame(in: .global).minX + 100))
                
                
                Spacer()
                
                // MARK: - PASSWORD GENERATOR
                
                VStack(alignment: .center, spacing: 20) {
                    
                    // MARK: - NEW PASSWORD
                    
                    Text("\(passwordGenerator.isRandom ? passwordGenerator.password : passwordGenerator.pin)")
                        .font(.title2)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .frame(width: 280, height: passwordGenerator.isRandom ? textHeight : 40, alignment: .center)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 8)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(passwordGenerator.getStrengthColor(for: Int(passwordGenerator.isRandom ? sliderValueRandom : sliderValuePin)), lineWidth: 2))
                    
                    
                    // MARK: - TOGGLE PASSWORDTYPE
                    
                    HStack {
                        
                        Button(action: {
                            sliderMinValue = 6
                            sliderMaxValue = 50
                            generateNewValues()
                            showToggles = true
                            passwordGenerator.isRandom = true
                            passwordGenerator.isPin = false
                            
                        }) {
                            Text("Random")
                                .font(.title2)
                                .frame(width: 100, height: 32, alignment: .center)
                                .background(passwordGenerator.isRandom ? Color.gray : Color.clear)
                                .foregroundColor(passwordGenerator.isRandom ? .black : .gray)
                        }
                        .cornerRadius(6.0)
                        
                        Spacer()
                        
                        Button(action: {
                            sliderMinValue = 3
                            sliderMaxValue = 20
                            generateNewValues()
                            showToggles = false
                            passwordGenerator.isRandom = false
                            passwordGenerator.isPin = true
                        }) {
                            Text("PIN")
                                .font(.title2)
                                .frame(width: 100, height: 32, alignment: .center)
                                .background(passwordGenerator.isPin ? Color.gray : Color.clear)
                                .foregroundColor(passwordGenerator.isPin ? .black : .gray)
                            
                        }
                        .cornerRadius(6.0)
                    } //: HSTACK
                    .frame(width: 200, height: 32, alignment: .center)
                    .border(Color.gray.opacity(0.4), width: 1)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(6.0)
                    .animation(Animation.easeOut(duration: 0.5))
                    
                    
                    
                    // MARK: - CHANGE PASSWORD LENGTH
                    
                    HStack {
                        Text("Länge: \(Int(passwordGenerator.isRandom ? sliderValueRandom : sliderValuePin))")
                            .font(.body)
                        
                        Slider(value: passwordGenerator.isRandom ? $sliderValueRandom : $sliderValuePin, in: sliderMinValue ... sliderMaxValue, step: 1, onEditingChanged: { ( value ) in
                            
                            if value == false {
                                generateNewValues()
                            }
                        })
                        .padding(.horizontal, 20)
                        .accentColor(.blue)
                    } //: HSTACK
                    
                    
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
                            if passwordGenerator.isRandom {
                                pasteboard.string = passwordGenerator.password
                            } else {
                                pasteboard.string = passwordGenerator.pin
                            }
                            // UIPasteboard.general.setValue("\(String(describing: password))", forPasteboardType: kUTTypePlainText as String)
                        }, label: {
                            Image(systemName: "doc.on.doc")
                                .font(.system(size: 32))
                            
                        })
                        
                        Spacer()
                            .frame(maxWidth: 300.0)
                        
                        // REFRESH BUTTON
                        
                        Button(action: {
                            generateNewValues()
                            
                        }, label: {
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 32))
                        })
                    } //: HSTACK
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
            generateNewValues()
        })
        
        .sheet(isPresented: $showingInfoView) {
            InfoView()
        }
    }
    
}


// MARK: - PREVIEW

struct ContentView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
        ContentView()
            .preferredColorScheme(.dark)
    }
}
