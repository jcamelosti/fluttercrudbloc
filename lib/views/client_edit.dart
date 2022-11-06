import 'package:crudblocsqlite/cubits/client_validation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crudblocsqlite/models/client.dart';
import '../cubits/client_cubit.dart';
import '../cubits/client_state.dart';

class ClientEditPage extends StatelessWidget {
  const ClientEditPage({Key? key, this.client}) : super(key: key);
  final Client? client;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: BlocProvider.of<ClientsCubit>(context),
        ),
        BlocProvider(
          create: (context) => ClientValidationCubit(),
        ),
      ],
      child: ClientsEditView(client: client),
    );
  }
}

class ClientsEditView extends StatelessWidget {
  ClientsEditView({
    Key? key,
    this.client,
  }) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _priceFocusNode = FocusNode();
  final Client? client;
  late String title = '';

  @override
  Widget build(BuildContext context) {
    // se for edicao de uma nota existente, os campos do formulario
    // sao preenchidos com os atributos da nota
    if (client == null) {
      _nameController.text = '';
      _phoneController.text = '';
      _priceController.text = '';
      title = 'Adicionar Cliente';
    } else {
      _nameController.text = client!.name;
      _phoneController.text = client!.phone;
      _priceController.text = client!.price.toString().replaceAll('.', ',');
      title = 'Editar Cliente';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: BlocListener<ClientsCubit, ClientsState>(
        listener: (context, state) {
          // a descricao dos estados esta no arquivo notes_state e os estados
          // nao tratados aqui sao utilizados na tela de lista de notas
          // print(state.toString());
          if (state is ClientsInitial) {
            const SizedBox();
          } else if (state is ClientsLoading) {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                });
          } else if (state is ClientsSuccess) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(
                content: Text('Operação realizada com sucesso'),
              ));
            // apos a nota ser salva, as notas sao recuperadas novamente e
            // o aplicativo apresenta novamenta a tela de lista de notas
            Navigator.pop(context);
            context.read<ClientsCubit>().buscarClientes();
          } else if (state is ClientsLoaded) {
            Navigator.pop(context);
          } else if (state is ClientsFailure) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(
                content: Text('Erro ao atualizar Cliente'),
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
                BlocBuilder<ClientValidationCubit, ClientValidationState>(
                  builder: (context, state) {
                    return TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Nome do Cliente',
                      ),
                      controller: _nameController,
                      focusNode: _nameFocusNode,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: _phoneFocusNode.requestFocus,
                      onChanged: (text) {
                        // a validacao eh realizada em toda alteracao do campo
                        context.read<ClientValidationCubit>().validaForm(
                            _nameController.text, _phoneController.text, 0.0);
                      },
                      onFieldSubmitted: (String value) {},
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        // o estado ClientsValidating eh emitido quando ha erro de
                        // validacao em qualquer campo do formulario e
                        // a mensagem de erro tambem eh apresentada
                        if (state is ClientValidating) {
                          if (state.nameMessage == '') {
                            return null;
                          } else {
                            return state.nameMessage;
                          }
                        }
                      },
                    );
                  },
                ),
                BlocBuilder<ClientValidationCubit, ClientValidationState>(
                  builder: (context, state) {
                    return TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Telefone',
                      ),
                      controller: _phoneController,
                      focusNode: _phoneFocusNode,
                      textInputAction: TextInputAction.done,
                      onChanged: (text) {
                        // a validacao eh realizada em toda alteracao do campo
                        context.read<ClientValidationCubit>().validaForm(
                            _nameController.text, _phoneController.text, tratarMoeda(_priceController.text));
                      },
                      onFieldSubmitted: (String value) {
                        if (_formKey.currentState!.validate()) {
                          //fechar teclado
                          FocusScope.of(context).unfocus();
                          context.read<ClientsCubit>().salvarCliente(client?.id,
                              _nameController.text, _phoneController.text, tratarMoeda(_priceController.text));
                        }
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        // o estado ClientsValidating eh emitido quando ha erro de
                        // validacao em qualquer campo do formulario e
                        // a mensagem de erro tambem eh apresentada
                        if (state is ClientValidating) {
                          if (state.phoneMessage == '') {
                            return null;
                          } else {
                            return state.phoneMessage;
                          }
                        }
                      },
                    );
                  },
                ),
                BlocBuilder<ClientValidationCubit, ClientValidationState>(
                  builder: (context, state) {
                    return TextFormField(
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9,]+')),],
                      decoration: const InputDecoration(
                        labelText: 'Valor(Hora)',
                      ),
                      controller: _priceController,
                      focusNode: _priceFocusNode,
                      textInputAction: TextInputAction.done,
                      onChanged: (text) {
                        // a validacao eh realizada em toda alteracao do campo
                        context.read<ClientValidationCubit>().validaForm(
                            _nameController.text, _phoneController.text, tratarMoeda(_priceController.text));
                      },
                      onFieldSubmitted: (String value) {
                        if (_formKey.currentState!.validate()) {
                          //fechar teclado
                          FocusScope.of(context).unfocus();
                          context.read<ClientsCubit>().salvarCliente(client?.id,
                              _nameController.text, _phoneController.text, tratarMoeda(_priceController.text));
                        }
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        // o estado ClientsValidating eh emitido quando ha erro de
                        // validacao em qualquer campo do formulario e
                        // a mensagem de erro tambem eh apresentada
                        if (state is ClientValidating) {
                          if (state.priceMessage == '') {
                            return null;
                          } else {
                            return state.priceMessage;
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
                    child: BlocBuilder<ClientValidationCubit,
                        ClientValidationState>(
                      builder: (context, state) {
                        // o botao de salvar eh habilitado somente quando
                        // o formulario eh completamente validado
                        return ElevatedButton(
                          onPressed: state is ClientValidated
                              ? () {
                                  if (_formKey.currentState!.validate()) {
                                    //fechar teclado
                                    FocusScope.of(context).unfocus();
                                    context.read<ClientsCubit>().salvarCliente(
                                        client?.id,
                                        _nameController.text,
                                        _phoneController.text,
                                        tratarMoeda(_priceController.text)
                                    );
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

  double tratarMoeda(String strValor){
    double valor = 0.0;

    if(strValor.isEmpty){
      valor = 0.0;
    }else{
      valor = double.parse( strValor.replaceAll(',', '.') );
    }

    return valor;
  }
}
