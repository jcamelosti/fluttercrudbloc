import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'note_validation_state.dart';

class NoteValidationCubit extends Cubit<NoteValidationState> {
  NoteValidationCubit() : super(const NoteValidating());

  //validar formulario de edicao da nota
  void validaForm(String titulo, String conteudo) {
    String cubitTituloMessage = '';
    String cubitConteudoMessage = '';
    bool formInvalid;

    formInvalid = false;
    if (titulo == '') {
      formInvalid = true;
      cubitTituloMessage = 'Preencha o título';
    } else {
      cubitTituloMessage = '';
    }
    if (conteudo == '') {
      formInvalid = true;
      cubitConteudoMessage = 'Preencha o conteúdo';
    } else {
      cubitConteudoMessage = '';
    }

    if (formInvalid == true) {
      emit(NoteValidating(
        tituloMessage: cubitTituloMessage,
        conteudoMessage: cubitConteudoMessage,
      ));
    } else {
      emit(const NoteValidated());
    }
  }
}