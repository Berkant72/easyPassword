//
//  ContentView.swift
//  Shared
//
//  Created by Berkant Dursun on 22.11.20.
//

import SwiftUI
import MobileCoreServices


struct ContentView: View {
    
    // MARK: - PROPERTIES

    @State private var sliderMinValue = 6.0
    @State private var sliderMaxValue = 50.0
    @State private var showingInfoView: Bool = false
    @State private var showToggles: Bool = true
    @StateObject var passwordGenerator = PasswordGenerator()
    
    let pasteboard = UIPasteboard.general
    
    
    var textHeight: CGFloat {
        switch passwordGenerator.sliderValueRandom {
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
                    
                    //                    HStack(alignment: .center, spacing: 2) {
                    //                    ForEach(0 ..< Int(passwordGenerator.sliderValueRandom), id: \.self) { char in
                    //                            Text(allCharacters.randomElement() ?? "")
                    //                            }
                    //
                    //   }
                    
                    Text("\(passwordGenerator.isPassword ? passwordGenerator.password : passwordGenerator.pin)")
                        .font(.title2)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .frame(width: 280, height: passwordGenerator.isPassword ? textHeight : 40, alignment: .center)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 8)
                        .overlay(
                            RoundedRectangle(
                                cornerRadius: 10)
                                .stroke(passwordGenerator.getStrengthColor(for: passwordGenerator.passwordQuality),
                                        lineWidth: 2)
                        )
                    
                    Text("\(passwordGenerator.getPasswordQuality().rawValue)")
                        .font(.subheadline)
                    
                    
                    
                    // MARK: - TOGGLE PASSWORDTYPE
                    
                    HStack {
                        
                        Button(action: {
                            sliderMinValue = 6
                            sliderMaxValue = 50
                            passwordGenerator.generateNewValues()
                            showToggles = true
                            passwordGenerator.isPassword = true
                            passwordGenerator.isPin = false
                            passwordGenerator.lastPassword = passwordGenerator.password
                        }) {
                            Text("Random")
                                .font(.title2)
                                .frame(width: 100, height: 32, alignment: .center)
                                .background(passwordGenerator.isPassword ? Color.gray : Color.clear)
                                .foregroundColor(passwordGenerator.isPassword ? .black : .gray)
                        }
                        .cornerRadius(6.0)
                        
                        Spacer()
                        
                        Button(action: {
                            sliderMinValue = 3
                            sliderMaxValue = 20
                            passwordGenerator.generateNewValues()
                            showToggles = false
                            passwordGenerator.isPassword = false
                            passwordGenerator.isPin = true
                            passwordGenerator.lastPin = passwordGenerator.pin
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
                        Text("Länge: \(Int(passwordGenerator.isPassword ? passwordGenerator.sliderValueRandom : passwordGenerator.sliderValuePin))")
                            .font(.body)
                        
                        Slider(value: passwordGenerator.isPassword ? $passwordGenerator.sliderValueRandom : $passwordGenerator.sliderValuePin, in: sliderMinValue ... sliderMaxValue, step: 1, onEditingChanged: { ( value ) in
                            
                            if value == false {
                                passwordGenerator.generateNewValues()
                            }
                        })
                        .padding(.horizontal, 20)
                        .accentColor(.blue)
                    } //: HSTACK
                    
                    
                    // MARK: - TOGGLES NUMBERS AND SYMBOLS
                    
                    if showToggles {
                        RandomOptionsView(numbers: $passwordGenerator.isNumber, symbols: $passwordGenerator.isSymbol)
                    } else {
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: 70)
                    }
                    
                    
                    
                    // MARK: - COPY PASSWORD OR REFRESH PASSWORD
                    
                    HStack {
                        
                        // COPY BUTTON
                        
                        Button(action: {
                            if passwordGenerator.isPassword {
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
                            .frame(maxWidth: 200.0)
                        
                        // REFRESH BUTTON
                        
                        Button(action: {
                            passwordGenerator.generateNewValues()
                            
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
            passwordGenerator.isPassword = true
            passwordGenerator.generateNewValues()
        })
        
        .sheet(isPresented: $showingInfoView) {
            InfoView()
        }
    }
    
}

//struct RandomOptionsView: View {
//    @Binding var numbers: Bool
//    @Binding var symbols: Bool
//    
//    var body: some View {
//        VStack {
//            Toggle("Zahlen", isOn: $numbers)
//                .toggleStyle(SwitchToggleStyle(tint: Color.blue))
//            Toggle("Symbole", isOn: $symbols)
//                .toggleStyle(SwitchToggleStyle(tint: Color.blue))
//            
//        }
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
