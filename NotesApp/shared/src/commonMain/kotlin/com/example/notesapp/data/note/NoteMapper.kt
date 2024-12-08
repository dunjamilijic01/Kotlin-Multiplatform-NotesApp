package com.example.notesapp.data.note

import database.Note
import kotlinx.datetime.Instant
import kotlinx.datetime.TimeZone
import kotlinx.datetime.toLocalDateTime

fun Note.toNote():com.example.notesapp.domain.note.Note{
    return com.example.notesapp.domain.note.Note(
        id=id,
        title = title,
        content = content,
        colorHex = colorHex,
        created = Instant.fromEpochMilliseconds(created).toLocalDateTime(TimeZone.currentSystemDefault())
    )
}