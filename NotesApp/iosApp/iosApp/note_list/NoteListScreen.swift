//
//  NoteListScreen.swift
//  iosApp
//
//  Created by Dunja Milijic on 1.12.24..
//  Copyright © 2024 orgName. All rights reserved.
//

import SwiftUI
import shared

struct NoteListScreen: View {
    
    private var noteDataSource: NoteDataSource
    @StateObject var viewModel = NoteListViewModel(noteDataSource: nil)
    
    @State private var isNoteSelected = false
    @State private var selectedNoteId:Int64? = nil
    
    init (noteDataSource: NoteDataSource) {
        self.noteDataSource = noteDataSource
        self.selectedNoteId = nil
    }
    
    
    
    var body: some View {
        VStack{
            
            ZStack{
                NavigationLink(
                    destination: NoteDetailScreen(noteDataSource: self.noteDataSource , noteId: selectedNoteId),
                    isActive: $isNoteSelected) {
                        EmptyView()
                    }.hidden()
                
                ToggableSearchTextField<NoteDetailScreen>(
                    onSearchToggled: {
                    viewModel.toggleIsSearchActive()
                        self.selectedNoteId=nil
                },
                    destinationProvider: {
                        NoteDetailScreen(
                            noteDataSource: noteDataSource,
                            noteId: selectedNoteId
                        )
                    },
                    isSearchActive: viewModel.isSearchActive,
                    searchText: $viewModel.searchText)
                .frame(maxWidth : .infinity, minHeight: 40)
                .padding()
                
                if(!viewModel.isSearchActive){
                    Text("All notes")
                        .font(.title2)
                    
                }
            }
            List{
                ForEach(viewModel.filteredNotes,id: \.self.id) { note in
                    Button(action:{
                        isNoteSelected = true
                        selectedNoteId = note.id?.int64Value
                    }){
                        NoteItem(note: note, onDelete:  {
                            viewModel.deleteNoteById(id: note.id?.int64Value)
                        })
                    }
                    
                }
            }
            .onAppear{
                viewModel.loadNotes()
            }
            .listStyle(.plain)
            .listRowSeparator(.hidden)
            
        }
        .onAppear{
            viewModel.setNoteDataSource(noteDataSource: noteDataSource)
            self.selectedNoteId = nil
        }
    }
}

#Preview {
    EmptyView()
}
