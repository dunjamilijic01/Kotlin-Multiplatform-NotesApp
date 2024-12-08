package com.example.notesapp.android.di

import android.app.Application
import app.cash.sqldelight.db.SqlDriver
import com.example.notesapp.data.local.DatabaseDriverFactory
import com.example.notesapp.data.note.SqlDelightNoteDataSource
import com.example.notesapp.domain.note.NoteDataSource
import com.swe.notesapp.database.NotesDatabase
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
object AppModule {
    @Provides
    @Singleton
    fun provideSqlDriver(app:Application):SqlDriver {
        return DatabaseDriverFactory(app).createDriver()
    }

    @Provides
    @Singleton
    fun provideNoteDataSource(driver:SqlDriver):NoteDataSource {
        return SqlDelightNoteDataSource(NotesDatabase(driver))
    }
}