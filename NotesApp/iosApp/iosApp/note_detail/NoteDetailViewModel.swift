//
//  NoteDetailViewModel.swift
//  iosApp
//
//  Created by Dunja Milijic on 1.12.24..
//  Copyright © 2024 orgName. All rights reserved.
//

import Foundation
import shared

extension NoteDetailScreen {
    @MainActor class NoteDetailViewModel : ObservableObject {
        private var notedataSource: NoteDataSource?
        
        private var noteId:Int64? = nil
        
        @Published var noteTitle = ""
        
        @Published var noteContnet = ""
        
        @Published private(set) var noteColor = Note.Companion().generateRandomColor()
        
        init(notedataSource: NoteDataSource? = nil) {
            self.notedataSource = notedataSource
            
        }
        
        func loadNoteIfExists(id: Int64?){
            if id != nil {
                self.noteId = id
                notedataSource?.getNoteById(id: id!, completionHandler: { note, error in
                    self.noteTitle = note?.title ?? ""
                    self.noteContnet = note?.content ?? ""
                    self.noteColor = note?.colorHex ?? Note.Companion().generateRandomColor()
                })
            }
        }
        
        func saveNote(onSaved: @escaping () -> Void){
            notedataSource?.createNote(
                note: Note(
                    id: noteId == nil ? nil : KotlinLong(value: noteId!),
                    title: self.noteTitle,
                    content: self.noteContnet,
                    colorHex: self.noteColor,
                    created: DateTimeUtil().now()),
                completionHandler: { error in
                    onSaved()
                })
        }
        
        
        func setParamsAndLoadNote (noteDataSource: NoteDataSource, noteId:Int64?){
            self.notedataSource = noteDataSource
            loadNoteIfExists(id: noteId)
        }
    }
}
