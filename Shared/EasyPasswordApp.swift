//
//  EasyPasswordApp.swift
//  Shared
//
//  Created by Berkant Dursun on 22.11.20.
//

import SwiftUI

@main
struct EasyPasswordApp: App {
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool =  false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(isDarkMode ? .dark : .light) 
//                .onDisappear(perform: {
//                    NSApplication.shared.terminate(self)
//                })
        }
        
    }
}
