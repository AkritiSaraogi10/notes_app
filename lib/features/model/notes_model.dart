class NotesModel {
  final String id;
  final String title;
  final String content;
  final String createdTime;
  int count;

  NotesModel(
      {this.id = "",
      this.title = "",
      this.content = "",
      this.createdTime = "",
      this.count = 3});
}

List<NotesModel> notesList = [];
