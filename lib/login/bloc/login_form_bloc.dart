import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../util/constant.dart';

class LoginFormBloc extends FormBloc<String, String> {
  final username = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,

      //  FieldBlocValidators.email,
    ],
  );

  final password = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );

  LoginFormBloc() {
    addFieldBlocs(
      fieldBlocs: [
        username,
        password,
      ],
    );
    // return super(null);
  }

  @override
  void onSubmitting() async {
    print(getStringAsync(kEmail));
    print(getStringAsync(kPassword));
    if (getStringAsync(kEmail) != username.value.toString().trim()) {
      emitFailure(failureResponse: 'invalid email');
      return;
    }
    if (getStringAsync(kPassword) != password.value.toString().trim()) {
      emitFailure(failureResponse: 'Please check your password');
      return;
    }
    await Future.delayed(const Duration(seconds: 2), () {
      setValue(kIsLoggedIn, true);
      emitSuccess();
    });

    /* 
   setValue(kToken, res.data.token);
        setValue(kIsLoggedIn, true);
        setValue(kFullName, res.data.name);
        setValue(kUid, res.data.id);
        setValue(kEmail, res.data.email); */

    //  emitFailure(failureResponse: 'This is an awesome error!');
  }
}
