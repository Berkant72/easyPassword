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
    
    @State private var showingInfoView: Bool = false
    @StateObject var passwordGenerator = PasswordGenerator()
    
    let pasteboard = UIPasteboard.general
    
    var textFrameHeight: CGFloat {
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
                    
                    Text("\(passwordGenerator.pickerSelection == 1 ? passwordGenerator.password : passwordGenerator.pin)")
                        .font(.title2)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .frame(width: 280, height: passwordGenerator.pickerSelection == 1 ? textFrameHeight : 44, alignment: .center)
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
                    
                    
                    Picker(
                        selection: $passwordGenerator.pickerSelection,
                        label: Text("Choose Options"))
                    {
                        Text("Random").tag(1)
                        Text("PIN").tag(2)
                    }
                    .onChange(of: passwordGenerator.pickerSelection, perform: { value in
                        
                        if value == 1 {
                            print("Random gewählt")
                            passwordGenerator.showToggles = true
                            passwordGenerator.generateNewValues()
                        } else {
                            print("PIN gewählt")
                            passwordGenerator.showToggles = false
                            passwordGenerator.generateNewValues()
                        }
                    })
                    .padding(.all)
                    .frame(width: 200, height: 44, alignment: .center)
                    .pickerStyle(SegmentedPickerStyle())
                    
                    
                    // MARK: - CHANGE PASSWORD LENGTH
                    
                    HStack {
                        Text("Länge: \(Int(passwordGenerator.pickerSelection == 1 ? passwordGenerator.sliderValueRandom : passwordGenerator.sliderValuePin))")
                            .font(.body)
                        
                        Slider(value: passwordGenerator.pickerSelection == 1 ? $passwordGenerator.sliderValueRandom : $passwordGenerator.sliderValuePin, in: passwordGenerator.sliderMinValue ... passwordGenerator.sliderMaxValue, step: 1, onEditingChanged: { ( value ) in
                            
                            if value == false {
                                passwordGenerator.generateNewValues()
                            }
                        })
                        .padding(.horizontal, 20)
                        .accentColor(.blue)
                        
                    } //: HSTACK
                    
                    
                    // MARK: - TOGGLES NUMBERS AND SYMBOLS
                    
                    if passwordGenerator.showToggles {
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
                            if passwordGenerator.pickerSelection == 1 {
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
            passwordGenerator.generateNewValues()
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
