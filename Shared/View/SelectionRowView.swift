//
//  SelectionRowView.swift
//  EasyPassword
//
//  Created by Berkant Dursun on 29.11.20.
//

import SwiftUI

struct SelectionRowView: View {
    
    // MARK: - PROPERTIES
    
    @Binding var checkedList: Bool
    var title: String
    
    // MARK: - BODY
    
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

// MARK: - PREVIEW

struct SelectionRowView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionRowView(checkedList: .constant(true), title: "SelectionRow")
            .previewLayout(.sizeThatFits)
    }
}
