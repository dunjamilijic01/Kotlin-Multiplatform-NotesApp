package com.example.notesapp.data.note

import com.example.notesapp.domain.note.Note
import com.example.notesapp.domain.note.NoteDataSource
import com.example.notesapp.domain.time.DateTimeUtil
import com.swe.notesapp.database.NotesDatabase

class SqlDelightNoteDataSource(db:NotesDatabase): NoteDataSource {

    private val queries = db.notesDatabaseQueries

    override suspend fun createNote(note: Note) {
        queries.insertNote(
            id = note.id,
            title = note.title,
            content = note.content,
            colorHex = note.colorHex,
            created = DateTimeUtil.toEpochMillis(note.created)
        )
    }

    override suspend fun getNoteById(id: Long): Note? {
        return queries
            .getNoteById(id)
            .executeAsOneOrNull()
            ?.toNote()

    }

    override suspend fun getAllNotes(): List<Note> {
        return queries
            .getAllNotes()
            .executeAsList()
            .map { it.toNote() }
    }

    override suspend fun deleteNote(id: Long) {
        queries.deleteNoteById(id)
    }
}