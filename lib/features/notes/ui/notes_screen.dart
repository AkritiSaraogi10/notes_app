import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_app/features/model/notes_model.dart';
import 'package:interview_app/features/notes/bloc/notes_bloc.dart';
import 'package:interview_app/features/notes_details/notes_details.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  NotesBloc notesBloc = NotesBloc();
  TextEditingController titleText = TextEditingController();
  TextEditingController contentText = TextEditingController();

  @override
  void initState() {
    notesBloc.add(NotesInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes App"),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        child: Column(children: [
          addNotesWidget(),
          Expanded(
            child: BlocConsumer<NotesBloc, NotesState>(
              buildWhen: (previous, current) => current is! NotesActionState,
              listenWhen: (previous, current) => current is NotesActionState,
              listener: (context, state) {},
              builder: (context, state) {
                print("state" + state.runtimeType.toString());
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
                          print("here ${successSate.notesList[index]}");
                          return notesWidget(successSate.notesList[index]);
                        });
                  default:
                    return SizedBox();
                }
              },
            ),
          )
        ]),
      ),
    );
  }

  Widget addNotesWidget() {
    return Column(
      children: [
        TextField(
          controller: titleText,
          decoration: const InputDecoration(hintText: "Add Title"),
        ),
        TextField(
          controller: contentText,
          decoration: const InputDecoration(hintText: "Add Content"),
        ),
        ElevatedButton(
            onPressed: () {
              if (titleText.text.isNotEmpty && contentText.text.isNotEmpty) {
                notesBloc.add(NotesAddEvent(
                    notesModel: NotesModel(
                        id: DateTime.now().toString(),
                        title: titleText.text,
                        content: contentText.text)));
              }
            },
            child: const Text("Add"))
      ],
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
      child: Column(
        children: [
          Text(notes.title),
          Text(notes.content),
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    notesBloc.add(NotesUpdateEvent(notesModel: notes));
                  },
                  icon: Icon(Icons.edit)),
              IconButton(
                  onPressed: () {
                    notesBloc.add(NotesDeleteEvent(id: notes.id));
                  },
                  icon: Icon(Icons.delete))
            ],
          )
        ],
      ),
    );
  }
}
