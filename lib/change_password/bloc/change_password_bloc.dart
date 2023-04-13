import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../util/constant.dart';

class ChangePassFormBloc extends FormBloc<String, String> {
  final username = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,

      //  FieldBlocValidators.email,
    ],
  );

  final oldPassword = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );
  final currentPassword = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );

  ChangePassFormBloc() {
    addFieldBlocs(
      fieldBlocs: [username, oldPassword, currentPassword],
    );
    // return super(null);
  }

  @override
  void onSubmitting() async {
    if (getStringAsync(kEmail) != username.value.toString().trim()) {
      emitFailure(failureResponse: 'invalid email');
      return;
    }
    if (getStringAsync(kPassword) != oldPassword.value.toString().trim()) {
      emitFailure(failureResponse: 'Please check your password');
      return;
    }
    setValue(kPassword, currentPassword.value.toString().trim());
    emitSuccess();

    /* 
   setValue(kToken, res.data.token);
        setValue(kIsLoggedIn, true);
        setValue(kFullName, res.data.name);
        setValue(kUid, res.data.id);
        setValue(kEmail, res.data.email); */

    //  emitFailure(failureResponse: 'This is an awesome error!');
  }
}
