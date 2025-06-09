// --- Models ---
import 'dart:ui';

import 'package:flutter/material.dart';

class Note {
  final String id;
  String title;
  String content;
  Color color;

  Note({required this.id, required this.title, required this.content, required this.color});
}

// --- Data Service (Placeholder) ---
class NotesService {
  List<Note> _notes = [
    Note(id: '1', title: 'Groceries', content: 'Milk, Eggs, Bread', color: Colors.yellow.shade100),
    Note(id: '2', title: 'Meeting Notes', content: 'Discuss project roadmap and deadlines.', color: Colors.blue.shade100),
    Note(id: '3', title: 'Ideas', content: 'Brainstorm new app features. Don\'t forget responsive design!', color: Colors.green.shade100),
    Note(id: '4', title: 'Workout Plan', content: 'Leg day: Squats, Lunges, Deadlifts', color: Colors.red.shade100),
  ];

  List<Note> get notes => _notes;

  void addNote(Note note) {
    _notes.add(note);
  }

  void updateNote(Note updatedNote) {
    int index = _notes.indexWhere((note) => note.id == updatedNote.id);
    if (index != -1) {
      _notes[index] = updatedNote;
    }
  }

  void deleteNote(String id) {
    _notes.removeWhere((note) => note.id == id);
  }
}