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
    
    @State private var sliderValue = 6.0
    @State private var password: String = ""
    @State private var showingInfoView: Bool = false
    @State private var isLetter: Bool = true
    @State private var isNumber: Bool = true
    @State private var isSpecial: Bool = true
    @State private var characters: [String] = ["easyPassword+"]
    
    
    let pasteboard = UIPasteboard.general
    let allCharacters = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","0","1","2","3","4","5","6","7","8","9","@","!","§","$","%","&","/","(",")","?"]
    
    let letters = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    let numbers = ["0","1","2","3","4","5","6","7","8","9"]
    let specials = ["@","!","§","$","%","&","/","(",")","?"]
    
    
    
    func generatePassword(_ from: [String], with length: Int) {
        characters = [""]
        
        switch true {
        case isLetter && isNumber && isSpecial:
            print("isletter and isNumber and isSpecial")
            characters = letters + numbers + specials
        case isLetter && isNumber:
            print("isLetter and isNumber")
            characters = letters + numbers
        case isNumber && isSpecial:
            print("isNumber and isSpecial")
            characters = numbers + specials
        case isLetter && isSpecial:
            print("isLetter an isSpecial")
            characters = letters + specials
        case isLetter:
            print("isLetter")
            characters.append(contentsOf: letters)
        case isNumber:
            print("isNumber")
            characters.append(contentsOf: numbers)
        case isSpecial:
            print("isSpecial")
            characters.append(contentsOf: specials)
        default:
            characters = [""]
        }
        
        for _ in 0..<length {
            password.append(characters.randomElement()!)
        }
        //        return password
    }
    
    // MARK: - BODY
    
    var body: some View {
        
        GeometryReader { geoReader in
            VStack(alignment: .center, spacing: 20) {
                
                // MARK: - Header
                
                HeaderView()
                    .frame(width: geoReader.size.width, height: 100, alignment: .center)
                    .position(CGPoint(x: geoReader.frame(in: .global).midX, y: geoReader.frame(in: .global).minX + 150))
                
                // MARK: - PASSWORD GENERATOR
                
                VStack(alignment: .center, spacing: 20) {
                    
                    // MARK: - NEW PASSWORD
                    
                    
                    Text("\(password)")
                        .padding(.vertical, 8)
                        .padding(.horizontal, 8)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10.0)
                    
                    Text("Länge: \(Int(sliderValue))")
                        .font(.body)
                    
                    // MARK: - CHANGE PASSWORD LENGTH
                    
                    Slider(value: $sliderValue, in: 1.0 ... 25.0, step: 1, onEditingChanged: { ( value ) in
                        // code
                        if value == false {
                            password = ""
                            generatePassword(characters, with: Int(sliderValue))
                        }
                    }, minimumValueLabel: Text("1"), maximumValueLabel: Text("25"), label: {
                        Text("My Slider")
                    })
                    .padding(.horizontal, 20)
                    
                    // MARK: - COPY PASSWORD
                    
                    Button(action: {
                        
                        pasteboard.string = password
                        //                    UIPasteboard.general.setValue("\(String(describing: password))",
                        //                                                  forPasteboardType: kUTTypePlainText as String)
                        
                        
                    }, label: {
                        Image(systemName: "doc.on.doc")
                            //                                    .accentColor(.black)
                            .font(.system(size: 32))
                    })
                    .accentColor(.blue)
                    .padding()
                    .padding(.horizontal, 20)
                    
                    // MARK: - TOGGLE CHARACTERS
                    
                    GroupBox {
                        ToggleView(checkedList: $isLetter, title: "Buchstaben")
                        ToggleView(checkedList: $isNumber, title: "Zahlen")
                        ToggleView(checkedList: $isSpecial, title: "Sonderzeichen")
                    }
                    
                    
                } //: VSTACK
                .padding(.bottom, 30)
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
            //            .frame(maxWidth: 720)
            
        } //: GEOMETRYREADER
        .edgesIgnoringSafeArea(.all)
        .onAppear(perform: {
                            
            generatePassword(characters, with: Int(sliderValue))
//            password = "easyPassword+"
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

struct ToggleView: View {
    
    @Binding var checkedList: Bool
    var title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title2)
            Spacer()
            Button(action: {
                checkedList.toggle()
            }, label: {
                Image(systemName: checkedList ? "checkmark.rectangle" : "rectangle")
                    .font(.system(size: 32))
                    .accentColor(.blue)
            })
        }
    }
}
