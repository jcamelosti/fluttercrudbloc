import 'package:bloc/bloc.dart';
import 'package:crudblocsqlite/dao/client_dao.dart';
import 'package:crudblocsqlite/models/client.dart';
import 'client_state.dart';


class ClientsCubit extends Cubit<ClientsState> {
  ClientsCubit():
        clientDao = ClientDAO(),
        super(const ClientsInitial());

  //instancia do banco de dados sqlite
  final ClientDAO? clientDao;

  //buscar todas os clientes
  Future<void> buscarClientes() async {
    emit(const ClientsLoading());
    try {
      final clients = await clientDao?.getClients();
      emit(ClientsLoaded(
        clients: clients,
      ));
    } on Exception {
      emit(const ClientsFailure());
    }
  }

  //excluir nota atraves um id
  Future<void> excluirCliente(id) async {
    emit(const ClientsLoading());

    // a linha abaixo nesse cubit simula tempo de processamento no servidor
    // serve para testar o circular indicator
    await Future.delayed(const Duration(seconds: 2));
    try {
      await clientDao?.delete(id);
      buscarClientes();
    } on Exception {
      emit(const ClientsFailure());
    }
  }

  //excluir todas as notas
  Future<void> excluirClientes() async {
    emit(const ClientsLoading());

    await Future.delayed(const Duration(seconds: 2));
    try {
      await clientDao?.deleteAll();
      emit(const ClientsLoaded(
        clients: [],
      ));
    } on Exception {
      emit(const ClientsFailure());
    }
  }

  //salvar nota
  Future<void> salvarCliente(int? id, String name, String phone, double price) async {
    Client editClient = Client(id: id, name: name, phone: phone, price: price);
    emit(const ClientsLoading());
    await Future.delayed(const Duration(seconds: 2));
    try {
      //se o metodo nao recebeu um id a nota sera incluida, caso contrario
      //a nota existente sera atualizada pelo id
      if (id == null) {
        //editNote = await _databaseProvider.save(editNote);
        clientDao?.save(editClient);
      } else {
        //editNote = await _databaseProvider.update(editNote);
        clientDao?.save(editClient);
      }
      emit(const ClientsSuccess());
      // buscarNotas();
    } on Exception {
      emit(const ClientsFailure());
    }
  }
}