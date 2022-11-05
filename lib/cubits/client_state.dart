import 'package:equatable/equatable.dart';

import '../models/client.dart';

abstract class ClientsState extends Equatable {
  const ClientsState();
}

// estado da tela inicial
class ClientsInitial extends ClientsState {
  const ClientsInitial();

  @override
  List<Object?> get props => [];
}

// aguardando operacao ser realizada
class ClientsLoading extends ClientsState {
  const ClientsLoading();

  @override
  List<Object?> get props => [];
}

// lista de clientes carregada
class ClientsLoaded extends ClientsState {
  const ClientsLoaded({
    this.clients,
  });

  final List<Client>? clients;

  ClientsLoaded copyWith({
    List<Client>? clients,
  }) {
    return ClientsLoaded(
      clients: clients ?? this.clients,
    );
  }

  @override
  List<Object?> get props => [clients];
}

// falha ao realizar operacao com cliente
class ClientsFailure extends ClientsState {
  const ClientsFailure();

  @override
  List<Object?> get props => [];
}

// operacao realizada com sucesso
class ClientsSuccess extends ClientsState {
  const ClientsSuccess();

  @override
  List<Object?> get props => [];
}