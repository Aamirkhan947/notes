import 'package:flutter/material.dart';

import 'note_model.dart';
import 'noteedit_screen.dart';

class NoteDetail extends StatelessWidget {
  final Note note;
  final Function(Note) onSave;
  final Function(String) onDelete;

  const NoteDetail({super.key, required this.note, required this.onSave, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            note.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Text(note.content),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NoteEditorScreen(note: note),
                    ),
                  );
                  if (result != null && result is Note) {
                    onSave(result);
                  }
                },
                child: const Text('Edit'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  onDelete(note.id);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
