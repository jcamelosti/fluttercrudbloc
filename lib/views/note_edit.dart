import 'package:crudblocsqlite/cubits/note_validation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crudblocsqlite/models/note.dart';
import '../cubits/note_cubit.dart';
import '../cubits/note_state.dart';

class NoteEditPage extends StatelessWidget {
  const NoteEditPage({Key? key, this.note}) : super(key: key);
  final Note? note;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: BlocProvider.of<NotesCubit>(context),
        ),
        BlocProvider(
          create: (context) => NoteValidationCubit(),
        ),
      ],
      child: NotesEditView(note: note),
    );
  }
}

class NotesEditView extends StatelessWidget {
  NotesEditView({
    Key? key,
    this.note,
  }) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _contentFocusNode = FocusNode();
  final Note? note;

  @override
  Widget build(BuildContext context) {
    // se for edicao de uma nota existente, os campos do formulario
    // sao preenchidos com os atributos da nota
    if (note == null) {
      _titleController.text = '';
      _contentController.text = '';
    } else {
      _titleController.text = note!.title;
      _contentController.text = note!.content;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bloc SQLite Crud - Editar Nota'),
      ),
      body: BlocListener<NotesCubit, NotesState>(
        listener: (context, state) {
          // a descricao dos estados esta no arquivo notes_state e os estados
          // nao tratados aqui sao utilizados na tela de lista de notas
          // print(state.toString());
          if (state is NotesInitial) {
            const SizedBox();
          } else if (state is NotesLoading) {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                });
          } else if (state is NotesSuccess) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(
                content: Text('Opera????o realizada com sucesso'),
              ));
            // apos a nota ser salva, as notas sao recuperadas novamente e
            // o aplicativo apresenta novamenta a tela de lista de notas
            Navigator.pop(context);
            context.read<NotesCubit>().buscarNotas();
          } else if (state is NotesLoaded) {
            Navigator.pop(context);
          } else if (state is NotesFailure) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(
                content: Text('Erro ao atualizar nota'),
              ));
          }
        },
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                BlocBuilder<NoteValidationCubit, NoteValidationState>(
                  builder: (context, state) {
                    return TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'T??tulo',
                      ),
                      controller: _titleController,
                      focusNode: _titleFocusNode,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: _contentFocusNode.requestFocus,
                      onChanged: (text) {
                        // a validacao eh realizada em toda alteracao do campo
                        context.read<NoteValidationCubit>().validaForm(
                            _titleController.text, _contentController.text);
                      },
                      onFieldSubmitted: (String value) {},
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        // o estado NotesValidating eh emitido quando ha erro de
                        // validacao em qualquer campo do formulario e
                        // a mensagem de erro tambem eh apresentada
                        if (state is NoteValidating) {
                          if (state.tituloMessage == '') {
                            return null;
                          } else {
                            return state.tituloMessage;
                          }
                        }
                      },
                    );
                  },
                ),
                BlocBuilder<NoteValidationCubit, NoteValidationState>(
                  builder: (context, state) {
                    return TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Conte??do',
                      ),
                      controller: _contentController,
                      focusNode: _contentFocusNode,
                      textInputAction: TextInputAction.done,
                      onChanged: (text) {
                        // a validacao eh realizada em toda alteracao do campo
                        context.read<NoteValidationCubit>().validaForm(
                            _titleController.text, _contentController.text);
                      },
                      onFieldSubmitted: (String value) {
                        if (_formKey.currentState!.validate()) {
                          //fechar teclado
                          FocusScope.of(context).unfocus();
                          context.read<NotesCubit>().salvarNota(note?.id,
                              _titleController.text, _contentController.text);
                        }
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        // o estado NotesValidating eh emitido quando ha erro de
                        // validacao em qualquer campo do formulario e
                        // a mensagem de erro tambem eh apresentada
                        if (state is NoteValidating) {
                          if (state.conteudoMessage == '') {
                            return null;
                          } else {
                            return state.conteudoMessage;
                          }
                        }
                      },
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child:
                    BlocBuilder<NoteValidationCubit, NoteValidationState>(
                      builder: (context, state) {
                        // o botao de salvar eh habilitado somente quando
                        // o formulario eh completamente validado
                        return ElevatedButton(
                          onPressed: state is NoteValidated
                              ? () {
                            if (_formKey.currentState!.validate()) {
                              //fechar teclado
                              FocusScope.of(context).unfocus();
                              context.read<NotesCubit>().salvarNota(
                                  note?.id,
                                  _titleController.text,
                                  _contentController.text);
                            }
                          }
                              : null,
                          child: const Text('Salvar'),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}