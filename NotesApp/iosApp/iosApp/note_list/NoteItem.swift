//
//  NoteItem.swift
//  iosApp
//
//  Created by Dunja Milijic on 1.12.24..
//  Copyright © 2024 orgName. All rights reserved.
//

import SwiftUI
import shared

struct NoteItem: View {
    
    var note:Note
    var onDelete:()->Void
    
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(note.title)
                    .font(.title3)
                    .fontWeight(.semibold)
                Spacer()
                Button(action : onDelete) {
                    Image(systemName: "xmark").foregroundColor(.black)
                }
            }.padding(.bottom,3)
            
            Text(note.content)
                .fontWeight(.light)
                .padding(.bottom,3)
            
            HStack {
                Spacer()
                Text(DateTimeUtil().formatDate(dateTime: note.created))
                    .fontWeight(.light)
                    .font(.footnote)
                
            }
            
            
        }
        .padding()
        .background(Color(hex: note.colorHex))
        .clipShape(RoundedRectangle(cornerRadius: 5.0))
    }
}

#Preview {
    NoteItem(
        note : Note(id:nil,title: "Mynote",content: "Content",colorHex: 0xffffff,created: DateTimeUtil().now()),
        onDelete: {}
    )
}
