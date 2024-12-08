//
//  NoteListViewModel.swift
//  iosApp
//
//  Created by Dunja Milijic on 1.12.24..
//  Copyright © 2024 orgName. All rights reserved.
//
import Foundation
import shared

extension NoteListScreen{
    @MainActor class NoteListViewModel :ObservableObject {
        private var noteDateSource:NoteDataSource?  = nil
        
        private let searchNotes = SearchNotes()
        
        private var notes = [Note]()
        @Published private(set) var filteredNotes = [Note]()
        @Published var searchText = ""{
            didSet {
                self.filteredNotes = searchNotes.search(notes: self.notes, searchString: searchText)
            }
        }
        
        @Published private(set) var isSearchActive = false
        
        init(noteDataSource: NoteDataSource? = nil){
            self.noteDateSource = noteDataSource
        }
        
        func loadNotes(){
            noteDateSource?.getAllNotes(completionHandler: {notes,error in
                self.notes = notes ?? []
                self.filteredNotes = self.notes
            })
        }
        
        func deleteNoteById(id : Int64?){
            if id != nil{
                noteDateSource?.deleteNote(id: id!, completionHandler: {error in
                    self.loadNotes()
                })
            }
        }
        
        func toggleIsSearchActive(){
            isSearchActive = !isSearchActive
            if !isSearchActive{
                searchText = ""
            }
        }
        
        func setNoteDataSource( noteDataSource: NoteDataSource){
            self.noteDateSource = noteDataSource
           
        }
        
        
    }
}

