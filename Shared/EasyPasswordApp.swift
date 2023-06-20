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
    @StateObject var passwordGenerator = PasswordGenerator()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(passwordGenerator)
                .preferredColorScheme(isDarkMode ? .dark : .light)
                
            #if os(macOS)
                .onDisappear(perform: {
                    NSApplication.shared.terminate(self)
                })
            #endif
                
        }
        
    }
}
