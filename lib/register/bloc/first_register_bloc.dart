import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../util/constant.dart';

class FirstFormBloc extends FormBloc<String, String> {
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

  FirstFormBloc() {
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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(kList, []);
    setValue(kEmail, username.value);
    setValue(kPassword, password.value);

    setValue(kPhoneNumber, '');
    setValue(kLastName, '');
    setValue(kFirstName, '');
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
