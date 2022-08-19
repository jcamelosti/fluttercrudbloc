import 'package:bloc/bloc.dart';
import 'package:crudblocsqlite/db/database_provider.dart';
import 'package:crudblocsqlite/models/note.dart';
import 'note_state.dart';


class NotesCubit extends Cubit<NotesState> {
  NotesCubit({required DatabaseProvider databaseProvider})
      : _databaseProvider = databaseProvider,
        super(const NotesInitial());

  //instancia do banco de dados sqlite
  final DatabaseProvider _databaseProvider;

  //buscar todas as notas
  Future<void> buscarNotas() async {
    emit(const NotesLoading());
    try {
      final notes = await _databaseProvider.buscarNotas();
      emit(NotesLoaded(
        notes: notes,
      ));
    } on Exception {
      emit(const NotesFailure());
    }
  }

  //excluir nota atraves um id
  Future<void> excluirNota(id) async {
    emit(const NotesLoading());

    // a linha abaixo nesse cubit simula tempo de processamento no servidor
    // serve para testar o circular indicator
    await Future.delayed(const Duration(seconds: 2));
    try {
      await _databaseProvider.delete(id);
      buscarNotas();
    } on Exception {
      emit(const NotesFailure());
    }
  }

  //excluir todas as notas
  Future<void> excluirNotas() async {
    emit(const NotesLoading());

    await Future.delayed(const Duration(seconds: 2));
    try {
      await _databaseProvider.deleteAll();
      emit(const NotesLoaded(
        notes: [],
      ));
    } on Exception {
      emit(const NotesFailure());
    }
  }

  //salvar nota
  Future<void> salvarNota(int? id, String titulo, String conteudo) async {
    Note editNote = Note(id: id, title: titulo, content: conteudo);
    emit(const NotesLoading());
    await Future.delayed(const Duration(seconds: 2));
    try {
      //se o metodo nao recebeu um id a nota sera incluida, caso contrario
      //a nota existente sera atualizada pelo id
      if (id == null) {
        editNote = await _databaseProvider.save(editNote);
      } else {
        editNote = await _databaseProvider.update(editNote);
      }
      emit(const NotesSuccess());
      // buscarNotas();
    } on Exception {
      emit(const NotesFailure());
    }
  }
}