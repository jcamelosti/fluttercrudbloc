import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'client_validation_state.dart';

class ClientValidationCubit extends Cubit<ClientValidationState> {
  ClientValidationCubit() : super(const ClientValidating());

  //validar formulario de edicao da nota
  void validaForm(String name, String phone, double price) {
    String cubitNameMessage = '';
    String cubitPhoneMessage = '';
    String cubitPriceMessage = '';

    bool formInvalid;

    formInvalid = false;

    //name
    if (name == '') {
      formInvalid = true;
      cubitNameMessage = 'Preencha o Nome do Cliente';
    } else {
      cubitNameMessage = '';
    }

    //phone
    if (phone == '') {
      formInvalid = true;
      cubitPhoneMessage = 'Preencha o Telefone do Cliente';
    } else {
      cubitPhoneMessage = '';
    }

    //price
    /*if (price == '') {
      formInvalid = true;
      cubitPriceMessage = 'Preencha o Valor da Hora';
    } else {
      cubitPriceMessage = '';
    }

    if (phone == '') {
      formInvalid = true;
      cubitPriceMessage = 'Preencha o Valor da Hora';
    } else {
      cubitPriceMessage = '';
    }*/

    if (formInvalid == true) {
      emit(ClientValidating(
        nameMessage: cubitNameMessage,
        phoneMessage: cubitPhoneMessage,
        priceMessage: cubitPriceMessage,
      ));
    } else {
      emit(const ClientValidated());
    }
  }
}