package com.example.notesapp.domain.note

import com.example.notesapp.domain.time.DateTimeUtil

class SearchNotes {
    fun search(notes:List<Note>, searchString:String):List<Note>{
        if(searchString.isBlank())
            return notes
        return notes.filter {
            it.title.trim().lowercase().contains(searchString.lowercase()) ||
                    it.content.trim().lowercase().contains(searchString.lowercase())
        }.sortedBy {
            DateTimeUtil.toEpochMillis(it.created)
        }
    }
}