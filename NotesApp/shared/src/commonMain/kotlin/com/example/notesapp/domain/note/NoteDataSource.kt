package com.example.notesapp.domain.note

interface NoteDataSource {
    suspend fun createNote(note:Note)
    suspend fun getNoteById(id:Long):Note?
    suspend fun getAllNotes():List<Note>
    suspend fun deleteNote(id:Long)

}