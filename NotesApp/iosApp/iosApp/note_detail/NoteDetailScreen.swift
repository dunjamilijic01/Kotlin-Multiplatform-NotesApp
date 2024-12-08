//
//  NoteDetailScreen.swift
//  iosApp
//
//  Created by Dunja Milijic on 1.12.24..
//  Copyright © 2024 orgName. All rights reserved.
//

import SwiftUI
import shared

struct NoteDetailScreen: View {
    
    private var noteDataSource: NoteDataSource
    private var noteId:Int64? = nil
    
    @StateObject var viewModel = NoteDetailViewModel(notedataSource: nil)
    @Environment(\.presentationMode) var presentation
    
    
    init(noteDataSource: NoteDataSource, noteId: Int64? = nil) {
        self.noteDataSource = noteDataSource
        self.noteId = noteId
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField("Enter a title", text: $viewModel.noteTitle)
                .font(.title).autocorrectionDisabled()
            TextField("Enter some content", text: $viewModel.noteContnet).autocorrectionDisabled()
            Spacer()
                
        }.toolbar(content: {
            Button(action: {
                viewModel.saveNote {
                    self.presentation.wrappedValue.dismiss()
                }
                
            }){
                Image(systemName: "checkmark")
            }
        })
        .padding()
        .background(Color(hex: viewModel.noteColor))
        .onAppear{
            viewModel.setParamsAndLoadNote(noteDataSource: noteDataSource, noteId: noteId)
        }
    }
}

#Preview {
    EmptyView()
}
