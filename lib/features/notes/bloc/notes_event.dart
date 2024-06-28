part of 'notes_bloc.dart';

@immutable
abstract class NotesEvent {}

class GetAllNotesInitialEvent extends NotesEvent {}

class NotesAddEvent extends NotesEvent {
  final NotesModel notesModel;

  NotesAddEvent({required this.notesModel});
}

class NotesUpdateEvent extends NotesEvent {
  final NotesModel notesModel;

  NotesUpdateEvent({required this.notesModel});
}

class NotesDeleteEvent extends NotesEvent {
  final String id;

  NotesDeleteEvent({required this.id});
}
