import 'package:flutter/material.dart';

import 'note_model.dart';

class NoteList extends StatelessWidget {
  final List<Note> notes;
  final Function(Note) onNoteSelected;

  const NoteList({super.key, required this.notes, required this.onNoteSelected});

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) {
      return const Center(child: Text('No notes yet! Add one.'));
    }
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return Card(
          color: note.color,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            title: Text(note.title),
            subtitle: Text(
              note.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () => onNoteSelected(note),
          ),
        );
      },
    );
  }
}