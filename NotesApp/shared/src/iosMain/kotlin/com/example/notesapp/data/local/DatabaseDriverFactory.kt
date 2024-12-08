package com.example.notesapp.data.local

import app.cash.sqldelight.driver.native.NativeSqliteDriver
import com.swe.notesapp.database.NotesDatabase

actual class DatabaseDriverFactory {
    actual fun createDriver():app.cash.sqldelight.db.SqlDriver{
        return NativeSqliteDriver(NotesDatabase.Schema,"note.db")
    }
}