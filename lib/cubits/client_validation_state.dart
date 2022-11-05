part of 'client_validation_cubit.dart';

abstract class ClientValidationState extends Equatable {
  const ClientValidationState();
}

// campos do formulario aguardando validacao com sucesso
class ClientValidating extends ClientValidationState {
  const ClientValidating({
    this.nameMessage,
    this.phoneMessage,
    this.priceMessage,
  });

  final String? nameMessage;
  final String? phoneMessage;
  final String? priceMessage;

  ClientValidating copyWith({
    String? nameMessage,
    String? phoneMessage,
    String? priceMessage,
  }) {
    return ClientValidating(
      nameMessage: nameMessage ?? this.nameMessage,
      phoneMessage: phoneMessage ?? this.phoneMessage,
      priceMessage: priceMessage ?? this.priceMessage,
    );
  }

  @override
  List<Object?> get props => [nameMessage, phoneMessage, priceMessage];
}

// campos do formulario validados com sucesso
class ClientValidated extends ClientValidationState {
  const ClientValidated();

  @override
  List<Object> get props => [];
}