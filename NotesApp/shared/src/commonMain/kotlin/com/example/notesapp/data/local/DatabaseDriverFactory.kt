package com.example.notesapp.data.local
import app.cash.sqldelight.db.SqlDriver

expect class DatabaseDriverFactory {
    fun createDriver():SqlDriver
}