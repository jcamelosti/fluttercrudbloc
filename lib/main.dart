import 'package:crudblocsqlite/cubits/client_cubit.dart';
import 'package:crudblocsqlite/views/note_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubits/note_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => {},
      child: MultiBlocProvider(
        providers: [
          BlocProvider<NotesCubit>(
            create: (BuildContext context) => NotesCubit(),
          ),
          BlocProvider<ClientsCubit>(
            create: (BuildContext context) => ClientsCubit(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const NoteListPage(),
        ),
      ),
    );
  }
}