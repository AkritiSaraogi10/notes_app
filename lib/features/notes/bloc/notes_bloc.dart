import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:interview_app/features/model/notes_model.dart';
import 'package:meta/meta.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesBloc() : super(NotesInitial()) {
    on<GetAllNotesInitialEvent>(notesInitialEvent);
    on<NotesAddEvent>(notesAddEvent);
    on<NotesUpdateEvent>(notesUpdateEvent);
    on<NotesDeleteEvent>(notesDeleteEvent);
  }
  FutureOr<void> notesInitialEvent(
      GetAllNotesInitialEvent event, Emitter<NotesState> emit) async {
    emit(NotesLoadingState());
    //Added the delay of 3 seconds to show loader
    await Future.delayed(const Duration(seconds: 3));
    emit(NotesSuccessLoadedState(notesList: notesList));
  }

  FutureOr<void> notesAddEvent(NotesAddEvent event, Emitter<NotesState> emit) {
    emit(NotesLoadingState());
    //added the new note
    notesList.add(event.notesModel);

    emit(NotesSuccessLoadedState(notesList: (notesList)));
  }

  FutureOr<void> notesUpdateEvent(
      NotesUpdateEvent event, Emitter<NotesState> emit) {
    emit(NotesLoadingState());
    int index =
        notesList.indexWhere((element) => element.id == event.notesModel.id);
    if (index != -1) {
      notesList[index] = event.notesModel;
    }
    emit(NotesSuccessLoadedState(notesList: notesList));
  }

  FutureOr<void> notesDeleteEvent(
      NotesDeleteEvent event, Emitter<NotesState> emit) {
    notesList.removeWhere((element) => element.id == event.id);
    emit(NotesSuccessLoadedState(notesList: notesList));
  }
}
