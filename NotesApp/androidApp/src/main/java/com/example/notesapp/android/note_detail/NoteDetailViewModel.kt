package com.example.notesapp.android.note_detail

import android.view.View
import androidx.compose.ui.graphics.Color
import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.notesapp.domain.note.Note
import com.example.notesapp.domain.note.NoteDataSource
import com.example.notesapp.domain.time.DateTimeUtil
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class NoteDetailViewModel @Inject constructor(
    private val noteDataSource: NoteDataSource,
    private val savedStateHandle: SavedStateHandle
):ViewModel(){

    private val noteTitle= savedStateHandle.getStateFlow("noteTitle","")
    private val isNoteTitleFocused= savedStateHandle.getStateFlow("isNoteTitleFocused",false)
    private val noteContent= savedStateHandle.getStateFlow("noteContent","")
    private val isNoteContentFocused= savedStateHandle.getStateFlow("isNoteContentFocused",false)
    private val noteColor= savedStateHandle.getStateFlow("noteColor",Note.generateRandomColor())

    val state = combine(
        noteTitle,
        isNoteTitleFocused,
        noteContent,
        isNoteContentFocused,
        noteColor
    ){ title,isTitleFocused,content,isContentFocused,color->
        NoteDetailState(
            noteTitle=title,
            isNoteTitleHintVisible = title.isEmpty() && !isTitleFocused,
            noteContent= content,
            isNoteContentHintVisible = content.isEmpty()&& !isContentFocused,
            noteColor = color
        )
    }.stateIn(viewModelScope, SharingStarted.WhileSubscribed(5000), NoteDetailState())

    private val _hasNoteBeenSaved = MutableStateFlow(false)
    val hasNoteBeenSaved = _hasNoteBeenSaved.asStateFlow()

    private var existingNoteId:Long?=null

    init {
        savedStateHandle.get<Long>("noteId")?.let { existingNoteId->
            if(existingNoteId== -1L){
                return@let
            }
            this.existingNoteId=existingNoteId
            viewModelScope.launch {
                noteDataSource.getNoteById(existingNoteId)?.let { note->
                    savedStateHandle["noteTitle"]=note.title
                    savedStateHandle["noteContent"]=note.content
                    savedStateHandle["noteColor"]=note.colorHex
                }
            }
        }
    }

    fun onNoteTitleChange(text:String){
        savedStateHandle["noteTitle"]=text
    }

    fun onNoteContentChange(text:String){
        savedStateHandle["noteContent"]=text
    }

    fun onNoteTitleFocusChange(isFocused:Boolean){
        savedStateHandle["isNoteTitleFocused"]=isFocused
    }

    fun onNoteContentFocusChange(isFocused:Boolean){
        savedStateHandle["isNoteContentFocused"]=isFocused
    }

    fun saveNote(){
        viewModelScope.launch {
            noteDataSource.createNote(
                Note(
                    id=existingNoteId,
                    title = noteTitle.value,
                    content = noteContent.value,
                    colorHex = noteColor.value,
                    created = DateTimeUtil.now()
                )
            )
            _hasNoteBeenSaved.value=true
        }
    }

}

