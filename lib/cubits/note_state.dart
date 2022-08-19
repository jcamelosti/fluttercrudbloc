import 'package:equatable/equatable.dart';

import '../models/note.dart';

abstract class NotesState extends Equatable {
  const NotesState();
}

// estado da tela inicial
class NotesInitial extends NotesState {
  const NotesInitial();

  @override
  List<Object?> get props => [];
}

// aguardando operacao ser realizada
class NotesLoading extends NotesState {
  const NotesLoading();

  @override
  List<Object?> get props => [];
}

// lista de notas carregada
class NotesLoaded extends NotesState {
  const NotesLoaded({
    this.notes,
  });

  final List<Note>? notes;

  NotesLoaded copyWith({
    List<Note>? notes,
  }) {
    return NotesLoaded(
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [notes];
}

// falha ao realizar operacao com notas
class NotesFailure extends NotesState {
  const NotesFailure();

  @override
  List<Object?> get props => [];
}

// operacao realizada com sucesso
class NotesSuccess extends NotesState {
  const NotesSuccess();

  @override
  List<Object?> get props => [];
}