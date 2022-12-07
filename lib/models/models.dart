import '../../utils/constants.dart';

class Note {
  String noteText = '';
  int? noteId;
  String? noteDate;
  String? updatedNoteDate;

  Note(
      {required this.noteText,
      this.noteId,
      this.noteDate,
      this.updatedNoteDate});

  //convert object -> Map
  Map<String, dynamic> toMap() {
    return {
      colId: noteId,
      colText: noteText,
      colDate: noteDate,
      colUpdateDate: updatedNoteDate
    };
  }

  //convert map to object
  Note.fromNote(Map<String, dynamic> map) {
    noteId = map[colId];
    noteText = map[colText];
    noteDate = map[colDate];
    updatedNoteDate = map[colUpdateDate];
  }
}
