import 'package:flutter/material.dart';
import 'package:interview_app/features/model/notes_model.dart';
import 'package:interview_app/features/notes/bloc/notes_bloc.dart';

class Alert extends StatefulWidget {
  final BuildContext context;
  final NotesBloc notesBloc;
  final NotesModel notesModel;
  final bool isUpdate;
  const Alert(
      {super.key,
      required this.context,
      required this.notesBloc,
      required this.notesModel,
      this.isUpdate = false});

  @override
  State<Alert> createState() => _AlertState();
}

class _AlertState extends State<Alert> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController titleText = TextEditingController();
  final TextEditingController contentText = TextEditingController();

  @override
  void initState() {
    if (widget.isUpdate) {
      titleText.text = widget.notesModel.title;
      contentText.text = widget.notesModel.content;
      super.initState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      backgroundColor: Colors.teal,
      content: Form(
        key: formKey,
        child: Material(
          type: MaterialType.card,
          child: (Column(
            children: [
              TextFormField(
                  controller: titleText,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  }),
              TextFormField(
                  controller: contentText,
                  decoration: const InputDecoration(
                    labelText: 'Body',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a body';
                    }
                    return null;
                  })
            ],
          )),
        ),
      ),
      actions: [
        ElevatedButton(
            onPressed: () {
              final title = titleText.text;
              final body = contentText.text;
              if (formKey.currentState?.validate() ?? false) {
                !widget.isUpdate
                    ? widget.notesBloc.add(NotesAddEvent(
                        notesModel: NotesModel(
                        id: DateTime.now().toString(),
                        title: title,
                        content: body,
                        createdTime: DateTime.now().toString(),
                      )))
                    : widget.notesBloc.add(NotesUpdateEvent(
                        notesModel: NotesModel(
                          id: widget.notesModel.id,
                          title: title,
                          content: body,
                          createdTime: DateTime.now().toString(),
                        ),
                      ));
                Navigator.of(context).pop();
              }
            },
            child: Text(widget.isUpdate ? "Update" : "Add"))
      ],
    );
  }
}
