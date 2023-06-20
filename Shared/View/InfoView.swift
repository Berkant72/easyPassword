//
//  InfoView.swift
//  EasyPassword
//
//  Created by Berkant Dursun on 28.11.20.
//

import SwiftUI

struct InfoView: View {
    
    // MARK: - // PROPERTIES
    
    @Environment(\.dismiss) var dismiss
    @AppStorage("isDarkMode") private var isDarkMode: Bool =  false

    private let keyVersion = "CFBundleShortVersionString"
    private let keyBundle = "CFBundleVersion"
    
    // MARK: - METHODS
    
    // Ermittelt die App Version
    private func getVersion() -> String {
        let infoDictionary = Bundle.main.infoDictionary!
        let versionNumber = infoDictionary[keyVersion] as! String
        return versionNumber
    }
    
    // Ermittelt die Build-Nummer
    private func getBuild() -> String {
        let infoDictionary = Bundle.main.infoDictionary!
        let buildNumber = infoDictionary[keyBundle] as! String
        return buildNumber
    }
    
    // MARK: - BODY
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            HeaderView()
                .frame(width: 350, height: 250, alignment: .center)
            
            Spacer()
            
            Form {
                Section(header: Text("Settings")) {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                        .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                }
            }.frame(height: 100)
            
            Form {
                Section(header: Text("About the application")) {
                    FormRowView(firstItem: "Application", secondItem: "EasyPassword+")
                    FormRowView(firstItem: "Platforms", secondItem: "iPhone, iPad, Macintosh")
                    FormRowView(firstItem: "Developer", secondItem: "Berkant Dursun")
                    FormRowView(firstItem: "Designer", secondItem: "Selim Dursun")
                    FormRowView(firstItem: "Website", secondItem: "www.berkantdursun.de")
                    FormRowView(firstItem: "Copyright", secondItem: "© 2020 All rights reserved.")
                    FormRowView(firstItem: "Version", secondItem: "\(getVersion())(\(getBuild()))")
                }
            }
            .font(.system(.body, design: .rounded))
        }
        .padding(.top, 40)
        .padding(20)
        .toolbar {
            Button {
                dismiss()
                
            } label: {
                Label("Close", systemImage: "xmark.circle")
            }
            .padding(.top, 30)
            .padding(.trailing, 20)
        }
    }
}

struct FormRowView: View {
    
    // MARK: - // PROPERTIES
    
    var firstItem: String
    var secondItem: String
    
    // MARK: - BODY
    
    var body: some View {
        HStack {
            Text(LocalizedStringKey("\(firstItem)"))
                .foregroundColor(.gray)
            Spacer()
            Text(LocalizedStringKey("\(secondItem)"))
        }
    }
}

// MARK: - PREVIEW
struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
