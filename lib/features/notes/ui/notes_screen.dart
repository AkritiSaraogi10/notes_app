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
              return ListView.builder(
                  itemCount: successSate.notesList.length,
                  itemBuilder: (context, index) {
                    return notesWidget(successSate.notesList[index]);
                  });
            default:
              return const SizedBox();
          }
        },
      ),
      floatingActionButton: IconButton(
        icon: const Icon(Icons.add),
        onPressed: () {
          _showAddPostDialog(context: context);
        },
      ),
    );
  }

  Widget notesWidget(NotesModel notes) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => NotesDetailsPage(
                  notesModel: notes,
                )));
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.grey.shade100),
        child: Column(
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
                              isUpdate: true);
                        },
                        icon: const Icon(Icons.edit)),
                    IconButton(
                        onPressed: () {
                          notesBloc.add(NotesDeleteEvent(id: notes.id));
                        },
                        icon: const Icon(Icons.delete))
                  ],
                ),
              ],
            ),
            Text("content : ${notes.content}"),
          ],
        ),
      ),
    );
  }

  void _showAddPostDialog(
      {required BuildContext context,
      isUpdate = false,
      NotesModel notesModel = const NotesModel()}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Alert(
          context: context,
          notesBloc: notesBloc,
          isUpdate: isUpdate,
          notesModel: notesModel,
        );
      },
    );
  }
}
