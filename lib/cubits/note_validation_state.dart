part of 'note_validation_cubit.dart';

abstract class NoteValidationState extends Equatable {
  const NoteValidationState();
}

// campos do formulario aguardando validacao com sucesso
class NoteValidating extends NoteValidationState {
  const NoteValidating({
    this.tituloMessage,
    this.conteudoMessage,
  });

  final String? tituloMessage;
  final String? conteudoMessage;

  NoteValidating copyWith({
    String? tituloMessage,
    String? conteudoMessage,
  }) {
    return NoteValidating(
      tituloMessage: tituloMessage ?? this.tituloMessage,
      conteudoMessage: conteudoMessage ?? this.conteudoMessage,
    );
  }

  @override
  List<Object?> get props => [tituloMessage, conteudoMessage];
}

// campos do formulario validados com sucesso
class NoteValidated extends NoteValidationState {
  const NoteValidated();

  @override
  List<Object> get props => [];
}