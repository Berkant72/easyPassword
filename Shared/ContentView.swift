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
    
    
//    func size(withAttributes attrs: [NSAttributedString.Key : Any]? = nil) -> CGSize
 
    
    var textFrameHeight: CGFloat {
        
        switch passwordGenerator.sliderValueRandom {
        case 0...20:
            return 32.0
        case 21...40:
            return 64.0
        default:
            return 18.0
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
                    
                    Text("\(passwordGenerator.pickerSelection == 1 ? passwordGenerator.password : passwordGenerator.pin)")
                        //                        .foregroundColor(passwordGenerator.pickerSelection == 2 ? .black : getColorForDigits(in: passwordGenerator.password))
                        .font(.title2)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
//                        .frame(width: geoReader.size.width - 20, height: passwordGenerator.pickerSelection == 1 ? textFrameHeight : 44, alignment: .center)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .overlay(
                            RoundedRectangle(
                                cornerRadius: 10)
                                .stroke(passwordGenerator.getStrengthColor(for: passwordGenerator.passwordQuality),
                                        lineWidth: 2)
                        )
                        .truncationMode(.middle)
                    
                    Text("\(passwordGenerator.getPasswordQuality().rawValue)")
                        .font(.body)
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
//                            print("Random gewählt")
                            passwordGenerator.showToggles = true
                            passwordGenerator.generateNewValues()
                        } else {
//                            print("PIN gewählt")
                            passwordGenerator.showToggles = false
                            passwordGenerator.generateNewValues()
                        }
                    })
//                    .padding(.all)
//                    .frame(width: 200, height: 44, alignment: .center)
                    .pickerStyle(SegmentedPickerStyle())
                    
                    
                    // MARK: - CHANGE PASSWORD LENGTH
                    
                    HStack {
                        Text("Länge: \(Int(passwordGenerator.pickerSelection == 1 ? passwordGenerator.sliderValueRandom : passwordGenerator.sliderValuePin))")
                            .font(.body)
                        
                        Slider(
                            value: passwordGenerator.pickerSelection == 1 ? $passwordGenerator.sliderValueRandom : $passwordGenerator.sliderValuePin,
                            in: passwordGenerator.sliderMinValue ... passwordGenerator.sliderMaxValue,
                            step: 1)
                            .onChange(of: Int(passwordGenerator.pickerSelection == 1 ? passwordGenerator.sliderValueRandom : passwordGenerator.sliderValuePin), perform: { ( _ ) in
                                passwordGenerator.generateNewValues()
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
                .padding(.bottom, 80)
                .frame(minWidth: 300, idealWidth: 375, maxWidth: 600, minHeight: 24, idealHeight: 30, maxHeight: .infinity, alignment: .center)
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
