import 'package:flutter/material.dart';

import 'note_details.dart';
import 'note_list.dart';
import 'note_model.dart';
import 'noteedit_screen.dart';

class NotesHomePage extends StatefulWidget {
  const NotesHomePage({super.key});

  @override
  State<NotesHomePage> createState() => _NotesHomePageState();
}

class _NotesHomePageState extends State<NotesHomePage> {
  final NotesService _notesService = NotesService();
  Note? _selectedNote;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showNoteEditor(context, null);
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            // Tablet/Desktop layout
            return Row(
              children: [
                SizedBox(
                  width: constraints.maxWidth * 0.35, // 35% for note list
                  child: NoteList(
                    notes: _notesService.notes,
                    onNoteSelected: (note) {
                      setState(() {
                        _selectedNote = note;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: _selectedNote == null
                      ? const Center(child: Text('Select a note to view'))
                      : NoteDetail(
                    note: _selectedNote!,
                    onSave: (updatedNote) {
                      setState(() {
                        _notesService.updateNote(updatedNote);
                        _selectedNote = updatedNote; // Update selected note
                      });
                    },
                    onDelete: (noteId) {
                      setState(() {
                        _notesService.deleteNote(noteId);
                        _selectedNote = null; // Clear selected note
                      });
                    },
                  ),
                ),
              ],
            );
          } else {
            // Mobile layout
            return NoteList(
              notes: _notesService.notes,
              onNoteSelected: (note) {
                _showNoteEditor(context, note);
              },
            );
          }
        },
      ),
      floatingActionButton:
      MediaQuery.of(context).size.width <= 600 // Only show FAB on mobile
          ? FloatingActionButton(
        onPressed: () {
          _showNoteEditor(context, null);
        },
        child: const Icon(Icons.add),
      )
          : null,
    );
  }

  void _showNoteEditor(BuildContext context, Note? note) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteEditorScreen(note: note),
      ),
    );

    if (result != null && result is Note) {
      setState(() {
        if (note == null) {
          _notesService.addNote(result);
        } else {
          _notesService.updateNote(result);
        }
      });
    } else if (result == 'deleted' && note != null) {
      setState(() {
        _notesService.deleteNote(note.id);
        _selectedNote = null; // Clear selected note if it was deleted
      });
    }
  }
}
