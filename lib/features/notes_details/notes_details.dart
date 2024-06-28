import 'package:flutter/material.dart';
import 'package:interview_app/features/model/notes_model.dart';

class NotesDetailsPage extends StatefulWidget {
  final NotesModel notesModel;
  const NotesDetailsPage({super.key, required this.notesModel});

  @override
  State<NotesDetailsPage> createState() => _NotesDetailsPageState();
}

class _NotesDetailsPageState extends State<NotesDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details Screen"),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        width: double.maxFinite,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.teal)),
        child: Column(children: [
          Text(widget.notesModel.title),
          Text(widget.notesModel.content)
        ]),
      ),
    );
  }
}
