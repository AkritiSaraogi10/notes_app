part of 'notes_bloc.dart';

@immutable
abstract class NotesState {}

abstract class NotesActionState extends NotesState {}

class NotesInitial extends NotesState {}

class NotesLoadingState extends NotesState {}

class NotesSuccessLoadedState extends NotesState {
  final List<NotesModel> notesList;

  NotesSuccessLoadedState({required this.notesList});
}

class NotesErrorState extends NotesState {}
