import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_app/features/model/notes_model.dart';
import 'package:interview_app/features/notes/bloc/notes_bloc.dart';
import 'package:interview_app/features/notes/ui/alert.dart';
import 'package:interview_app/features/notes_details/notes_details.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  NotesBloc notesBloc = NotesBloc();
  late Timer timer;

  @override
  void initState() {
    super.initState();
    startReminderCheck();
  }

  void startReminderCheck() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        if (notesBloc.state is NotesSuccessLoadedState) {
          NotesSuccessLoadedState successState =
              notesBloc.state as NotesSuccessLoadedState;
          List<NotesModel> notesList = successState.notesList;

          for (int i = 0; i < notesList.length; i++) {
            NotesModel note = notesList[i];
            note.count =
                calculateRemindersLeft(note.createdTime, DateTime.now());
          }
        }
      });
    });
  }

//took help from Internet
  int calculateRemindersLeft(String createdTime, DateTime currentTime) {
    DateTime targetTime5Min =
        DateTime.parse(createdTime).add(Duration(minutes: 5));
    DateTime targetTime10Min =
        DateTime.parse(createdTime).add(Duration(minutes: 15));
    DateTime targetTime15Min =
        DateTime.parse(createdTime).add(Duration(minutes: 30));

    int remindersLeft = 3;

    if (currentTime.isAfter(targetTime5Min)) {
      remindersLeft = 2;
    }
    if (currentTime.isAfter(targetTime10Min)) {
      remindersLeft = 1;
    }
    if (currentTime.isAfter(targetTime15Min)) {
      remindersLeft = 0;
    }

    return remindersLeft;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes App"),
        backgroundColor: Colors.teal,
      ),
      body: BlocConsumer<NotesBloc, NotesState>(
        bloc: notesBloc, // this was missed
        buildWhen: (previous, current) => current is! NotesActionState,
        listenWhen: (previous, current) => current is NotesActionState,
        listener: (context, state) {},
        builder: (context, state) {
          switch (state.runtimeType) {
            case NotesLoadingState:
              return const Center(
                child: CircularProgressIndicator(),
              );

            case NotesSuccessLoadedState:
              final successSate = state as NotesSuccessLoadedState;
              return successSate.notesList.isNotEmpty
                  ? ListView.builder(
                      itemCount: successSate.notesList.length,
                      itemBuilder: (context, index) {
                        return notesWidget(successSate.notesList[index]);
                      },
                    )
                  : const Center(
                      child: Text("Please add notes using + button "));

            default:
              return const SizedBox();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddPostDialog(context: context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget notesWidget(NotesModel notes) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => NotesDetailsPage(
            notesModel: notes,
          ),
        ));
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.grey.shade100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Title: ${notes.title}"),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        _showAddPostDialog(
                          context: context,
                          notesModel: notes,
                          isUpdate: true,
                        );
                      },
                      icon: const Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () {
                        notesBloc.add(NotesDeleteEvent(id: notes.id));
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              ],
            ),
            Text("Content: ${notes.content}"),
            Text("Reminder: ${notes.count}"), // Display reminder count
          ],
        ),
      ),
    );
  }

  void _showAddPostDialog({
    required BuildContext context,
    isUpdate = false,
    NotesModel? notesModel,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Alert(
          context: context,
          notesBloc: notesBloc,
          isUpdate: isUpdate,
          notesModel: notesModel ?? NotesModel(),
        );
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
