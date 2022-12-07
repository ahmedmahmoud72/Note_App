import 'package:flutter/material.dart';
import 'package:ieee_note_app/models/models.dart';
import 'package:ieee_note_app/network/local/CURD.dart';
import 'package:ieee_note_app/utils/datetime_manager.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var formKey = GlobalKey<FormState>();
  TextEditingController noteController = TextEditingController();
  CURD? _curd;
  List<Note> _notes = [];
  TextEditingController? _editController;
  var _editKey;

  @override
  void initState() {
    _curd = CURD();
    viewNotes();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note App'),
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: noteController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    labelText: ('Note'),
                    prefixIcon: const Icon(Icons.note_add),
                  ),
                  onFieldSubmitted: (value) {
                    print(value);
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return ('Enter your note');
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Container(
                    height: 40,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.blue,
                    ),
                    child: MaterialButton(
                        child: const Text('Add note',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            String text = noteController.value.text;
                            Note note = Note(
                              noteText: text,
                              noteDate: DateTimeManager.currentDateTime(),
                            );
                            saveMyNote(note);
                          }
                        }),
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                ListView.builder(
                  itemCount: _notes.length,
                  itemBuilder: (context, index) => ListTile(
                    leading: Icon(Icons.note),
                    title: Text(_notes[index].noteText),
                    subtitle: Text(_notes[index].noteDate!),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(children: [
                        IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: const Text('Delete note'),
                                        actions: [
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text('Cancel')),
                                          TextButton(
                                              onPressed: () {
                                                deleteNote(
                                                    _notes[index].noteId);
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Delete')),
                                        ],
                                      ));
                            },
                            icon: const Icon(Icons.delete)),
                        IconButton(
                            onPressed: () {
                              _openEditDialog(_notes[index]);
                            },
                            icon: const Icon(Icons.edit))
                      ]),
                    ),
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void saveMyNote(Note note) {
    _curd!.insert(note).then((value) {
      if (value > 0) {
        print('$value rows is inserted');
        noteController.text = '';
        viewNotes();
      }
    });
  }

  void viewNotes() {
    _curd?.query().then((value) {
      setState(() {
        _notes = value;
      });
    });
  }

  void deleteNote(int? noteId) {
    _curd?.delete(noteId).then((value) {
      if (value > 0) {
        print('$value note deleted');
        viewNotes();
      }
    });
  }

  void updateNote(Note note) {
    _curd?.update(note).then((value) {
      if (value > 0) {
        print('1 note updated');
        viewNotes();
      }
    });
  }

  _openEditDialog(Note note) {
    _editController = TextEditingController(text: note.noteText);
    _editKey = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Update Note'),
              content: Form(
                  key: _editKey,
                  child: TextFormField(
                      controller: _editController,
                      validator: (value) =>
                          value!.isEmpty ? 'Note is required' : null,
                      decoration: const InputDecoration(
                          labelText: 'Note', hintText: 'Write your Note'))),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel')),
                TextButton(
                    onPressed: () {
                      if (_editKey!.currentState!.validate()) {
                        String newText = _editController!.value.text;
                        note.noteText = newText;
                        note.updatedNoteDate =
                            DateTimeManager.currentDateTime();
                      }
                      updateNote(note);
                      Navigator.pop(context);
                    },
                    child: const Text('Update'))
              ],
            ));
  }
}
