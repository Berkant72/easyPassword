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
                
                VStack(alignment: .center, spacing: 10) {
                    
                    // MARK: - NEW PASSWORD
                    
                    Text("\(passwordGenerator.pickerSelection == 1 ? passwordGenerator.password : passwordGenerator.pin)")
                        .modifier(passwordTextModifier())
                        .overlay(
                            RoundedRectangle(
                                cornerRadius: 10)
                                .stroke(passwordGenerator.getStrengthColor(for: passwordGenerator.passwordQuality),
                                        lineWidth: 2)
                        )
                        .fixedSize(horizontal: false, vertical: true) // Used fixed size to expand the text vertically
                    
                    Text("\(passwordGenerator.getPasswordQuality().rawValue)")
                        .font(.title2) 
                        .foregroundColor(passwordGenerator.getStrengthColor(for: passwordGenerator.passwordQuality))
                    
                    
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
                            passwordGenerator.showToggles = true
                            passwordGenerator.generateNewValues()
                        } else {
                            passwordGenerator.showToggles = false
                            passwordGenerator.generateNewValues()
                        }
                    })
                    .pickerStyle(SegmentedPickerStyle())
                    
                    
                    // MARK: - CHANGE PASSWORD LENGTH
                    
                    HStack(spacing: 8) {
                        Text("Length: \(Int(passwordGenerator.pickerSelection == 1 ? passwordGenerator.sliderValueRandom : passwordGenerator.sliderValuePin))")
                            .font(.body)
                        
                        Slider(
                            value: passwordGenerator.pickerSelection == 1 ? $passwordGenerator.sliderValueRandom : $passwordGenerator.sliderValuePin,
                            in: passwordGenerator.sliderMinValue ... passwordGenerator.sliderMaxValue,
                            step: 1)
                            .onChange(of: Int(passwordGenerator.pickerSelection == 1 ? passwordGenerator.sliderValueRandom : passwordGenerator.sliderValuePin), perform: { ( _ ) in
                                passwordGenerator.generateNewValues()
                            })
                        
                    } //: HSTACK
                    
                    
                    // MARK: - TOGGLES NUMBERS AND SYMBOLS
                    
                    if passwordGenerator.showToggles {
                        RandomOptionsView(passwordGenerator: passwordGenerator)
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
                .padding(.bottom, 80)
                .padding(.horizontal, 20)
                .frame(minWidth: 300, idealWidth: 375, maxWidth: 800, minHeight: 250, idealHeight: 300, maxHeight: 600, alignment: .center)
            } //: VSTACK
            .overlay(
                // INFO
                Button(action: {
                showingInfoView = true
            }, label: {
                Image(systemName: "info.circle")
            })
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
    }
}
