part of 'notes_bloc.dart';

@immutable
abstract class NotesEvent {}

class NotesInitialEvent extends NotesEvent {}

class NotesAddEvent extends NotesEvent {
  final NotesModel notesModel;

  NotesAddEvent({required this.notesModel});
  // final String id;
  // final String title;
  // final String content;

  // NotesAddEvent({required this.id, required this.title, required this.content});
}

class NotesUpdateEvent extends NotesEvent {
  final NotesModel notesModel;

  NotesUpdateEvent({required this.notesModel});
}

class NotesDeleteEvent extends NotesEvent {
  final String id;

  NotesDeleteEvent({required this.id});
}
