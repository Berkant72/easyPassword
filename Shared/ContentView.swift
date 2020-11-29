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
    @State private var showingInfoView: Bool = false
    @StateObject var pwGenarator = PasswordGenerator()
    
    let pasteboard = UIPasteboard.general

    
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
                    
                    
                    Text("\(pwGenarator.password)")
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
                            pwGenarator.password = ""
                            pwGenarator.generatePassword(pwGenarator.characters, with: Int(sliderValue))
                        }
                    }, minimumValueLabel: Text("1"), maximumValueLabel: Text("25"), label: {
                        Text("My Slider")
                    })
                    .padding(.horizontal, 20)
                    .accentColor(.blue)
                    // MARK: - COPY PASSWORD
                    
                    Button(action: {
                        
                        pasteboard.string = pwGenarator.password
                        //                    UIPasteboard.general.setValue("\(String(describing: password))",
                        //                                                  forPasteboardType: kUTTypePlainText as String)
                        
                        
                    }, label: {
                        Image(systemName: "doc.on.doc")
                            .accentColor(.blue)
                            .font(.system(size: 32))
                    })
                    .accentColor(.blue)
                    .padding()
                    .padding(.horizontal, 20)
                    
                    // MARK: - TOGGLE CHARACTERS
                    
                    GroupBox {
                        SelectionRowView(checkedList: $pwGenarator.isLetter, title: "Buchstaben")
                        SelectionRowView(checkedList: $pwGenarator.isNumber, title: "Zahlen")
                        SelectionRowView(checkedList: $pwGenarator.isSpecial, title: "Sonderzeichen")
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
            
        } //: GEOMETRYREADER
        .edgesIgnoringSafeArea(.all)
        .onAppear(perform: {
                            
            pwGenarator.generatePassword(pwGenarator.characters, with: Int(sliderValue))
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
//
    }
}
