import 'package:crudblocsqlite/cubits/client_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/client_state.dart';
import '../models/client.dart';
import 'client_edit.dart';

class ClientListPage extends StatelessWidget {
  const ClientListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<ClientsCubit>(context)..buscarClientes(),
      child: const ClientsView(),
    );
  }
}

class ClientsView extends StatelessWidget {
  const ClientsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Clientes'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {
              // excluir todas as notas
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Excluir Todas as Clientes'),
                  content: const Text('Confirmar operação?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<ClientsCubit>().excluirClientes();
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(const SnackBar(
                            content: Text('Clientes excluídos com sucesso'),
                          ));
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: const _Content(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // como o FAB cria uma nota nova, a nota nao eh parametro recebido
          // na tela de edicao
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ClientEditPage(client: null)),
          );
        },
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ClientsCubit>().state;
    // a descricao dos estados esta no arquivo notes_state
    // os estados nao tratados aqui sao utilizados na tela de edicao da nota
    // print('notelist ' + state.toString());
    if (state is ClientsInitial) {
      return const SizedBox();
    } else if (state is ClientsLoading) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    } else if (state is ClientsLoaded) {
      //a mensagem abaixo aparece se a lista de notas estiver vazia
      if (state.clients!.isEmpty) {
        return const Center(
          child: Text('Não há clientes. Clique no botão abaixo para cadastrar.'),
        );
      } else {
        return _ClientsList(state.clients);
      }
    } else {
      return const Center(
        child: Text('Erro ao recuperar Clientes.'),
      );
    }
  }
}

class _ClientsList extends StatelessWidget {
  const _ClientsList(this.clients, {Key? key}) : super(key: key);
  final List<Client>? clients;
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (final client in clients!) ...[
          Padding(
            padding: const EdgeInsets.all(2.5),
            child: ListTile(
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              title: Text(client.name + ' ' +client.price.toString()),
              subtitle: Text(
                client.phone,
              ),
              trailing: Wrap(children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        // a nota existente eh enviada como parametro para a
                        // tela de edicao preencher os campos automaticamente
                          builder: (context) => ClientEditPage(client: client)),
                    );
                  },
                ),
                IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      // excluir nota atraves do id
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Excluir Cliente'),
                          content: const Text('Confirmar operação?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () {
                                context.read<ClientsCubit>().excluirCliente(client.id);
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(const SnackBar(
                                    content: Text('Cliente excluído com sucesso'),
                                  ));
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }),
              ]),
            ),
          ),
          // const Divider(
          //   height: 2,
          // ),
        ],
      ],
    );
  }
}