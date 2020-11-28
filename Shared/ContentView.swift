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
    
    let pasteboard = UIPasteboard.general
    var allCharacters = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","0","1","2","3","4","5","6","7","8","9","@","!","§","$","%","&","/","(",")","?"]
    
    
    func generateCharacters(_ from: [String], with length: Int) -> String {
        
        for _ in 0..<length {
            password.append(allCharacters.randomElement()!)
        }
        return password
    }
    
    // MARK: - BODY
    
    var body: some View {
                
                GeometryReader { geoReader in
                    VStack(alignment: .center, spacing: 20) {
                        
                        HeaderView()
                            .frame(width: geoReader.size.width, height: 100, alignment: .center)
                            .position(CGPoint(x: geoReader.frame(in: .global).midX, y: geoReader.frame(in: .global).minX + 150))

                        
                        HStack(alignment: .center, spacing: 2) {
                            Text("\(password)")
                            //                    ForEach(1...length, id: \.self) { _ in
                            //
                            //                        Text("\(allCharacters.randomElement() ?? "")")
                            //                            .font(.callout)
                            //                            .onTapGesture(count: 2) {
                            //                                UIPasteboard.general.setValue("\(String(describing: allCharacters.randomElement()))",
                            //                                    forPasteboardType: kUTTypePlainText as String)
                            //                            }
                            
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 8)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10.0)
                        
                        
                        VStack(alignment: .center, spacing: 20) {
                            
                            Slider(value: $sliderValue, in: 1.0 ... 25.0, step: 1, onEditingChanged: { ( value ) in
                                // code
                                if value == false {
                                    password = ""
                                    password = generateCharacters(allCharacters, with: Int(sliderValue))
                                }
                            }, minimumValueLabel: Text("1"), maximumValueLabel: Text("25"), label: {
                                Text("My Slider")
                            })
                            .padding(.horizontal, 20)
                            
                            Text("\(Int(sliderValue))")
                            
                            
                            Button(action: {
                                
                                pasteboard.string = password
                                //                    UIPasteboard.general.setValue("\(String(describing: password))",
                                //                                                  forPasteboardType: kUTTypePlainText as String)
                                
                                
                            }, label: {
                                Image(systemName: "doc.on.doc")
                                    .accentColor(.black)
                                    .font(.system(size: 32))
                            })
                            .padding()
                            .padding(.horizontal, 20)
                            Spacer()
                        } //: VSTACK
                        
                    } //: VSTACK
                    .overlay(
                    // INFO
                        Button(action: {
                            showingInfoView = true
                        }, label: {
                            Image(systemName: "info.circle")
                        })
                        .accentColor(.gray)
                        .font(.title),
                        alignment: .topTrailing
                    )
                    .padding(.vertical, 50)
                    .padding(.horizontal, 8)
                    .frame(maxWidth: 720)

                } //: GEOMETRYREADER
            .edgesIgnoringSafeArea(.all)
//            .frame(width: 400, height: 200, alignment: .center)
            .onAppear(perform: {
    //            animateTitle = true
                password = generateCharacters(allCharacters, with: Int(sliderValue))
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
