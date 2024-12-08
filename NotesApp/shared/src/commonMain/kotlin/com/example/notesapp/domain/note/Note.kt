package com.example.notesapp.domain.note

import com.example.notesapp.presentation.*
import kotlinx.datetime.LocalDateTime

data class Note(
    val id:Long?,
    val title:String,
    val content:String,
    val colorHex:Long,
    val created:LocalDateTime
)
{
    companion object{
        private val colors= listOf(ligthBlue,purple,yellow,orange,pink)

        fun generateRandomColor()= colors.random()
    }
}
