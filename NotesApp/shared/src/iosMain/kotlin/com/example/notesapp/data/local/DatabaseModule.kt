package com.example.notesapp.data.local

import com.example.notesapp.data.note.SqlDelightNoteDataSource
import com.example.notesapp.domain.note.NoteDataSource
import com.swe.notesapp.database.NotesDatabase

class DatabaseModule {
    private val factory by lazy {DatabaseDriverFactory()}
    public val noteDataSource : NoteDataSource by lazy {
        SqlDelightNoteDataSource(NotesDatabase(factory.createDriver()))
    }
}
