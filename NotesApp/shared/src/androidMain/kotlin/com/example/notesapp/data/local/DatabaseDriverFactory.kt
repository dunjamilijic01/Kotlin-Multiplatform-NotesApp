package com.example.notesapp.data.local

import android.content.Context
import app.cash.sqldelight.driver.android.AndroidSqliteDriver
import app.cash.sqldelight.db.SqlDriver
import com.swe.notesapp.database.NotesDatabase
import database.Note
import database.NotesDatabaseQueries

actual class DatabaseDriverFactory(private val context:Context) {
    actual fun createDriver():SqlDriver{
        return AndroidSqliteDriver(NotesDatabase.Schema,context,"note.db")
    }
}