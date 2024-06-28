class NotesModel {
  final String id;
  final String title;
  final String content;
  final String reminderTime;

  const NotesModel({
    this.id = "",
    this.title = "",
    this.content = "",
    this.reminderTime = "",
  });
}

List<NotesModel> notesList = [];
