import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_app/features/notes/bloc/notes_bloc.dart';
import 'package:interview_app/features/notes/ui/notes_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (_) => NotesBloc()..add(GetAllNotesInitialEvent()),
        child: const NotesScreen(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
