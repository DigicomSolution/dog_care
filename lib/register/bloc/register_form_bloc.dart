import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../util/constant.dart';

class SignupFormBloc extends FormBloc<String, String> {
  //String invalidMail = 'da';
  final fName = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final lName = TextFieldBloc(
    validators: [FieldBlocValidators.required],
  );
  final pupName = TextFieldBloc(
    validators: [FieldBlocValidators.required],
  );

  final agreeToConditions = BooleanFieldBloc(
    validators: [FieldBlocValidators.required],
  );
  // final numberCode = BooleanFieldBloc(
  //   validators: [FieldBlocValidators.required],
  // );

  //final UserRepository _userRepository;

  SignupFormBloc() {
    addFieldBlocs(
      // fieldBlocs: [fName, lName, pupName, numberCode, agreeToConditions],
      fieldBlocs: [fName, lName, pupName, agreeToConditions],
    );
    // Obtain shared preferences.

    // username.addAsyncValidators([_checkUsername]);
  }

/*   static String? _validateEmail(String? email) {
    bool isValidEmail = email!.trim().validateEmail();
    if (!isValidEmail) {
      return 'Please enter a valid email address';
    }
    return null;
  }
 */

  @override
  void onSubmitting() async {
    try {
      /*  setValue(kIsLoggedIn, true);
          setValue(kFullName, res.data.name);
          setValue(kUid, res.data.id);
          setValue(kEmail, res.data.email); */
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final List<String> items = prefs.getStringList(kList) ?? [];
      // String number = getStringAsync(kPhoneNumber).contains('+')
      //     ? getStringAsync(kPhoneNumber).split('+').last
      //     : getStringAsync(kPhoneNumber);

      var model = <String, String>{
        'firstname': fName.value,
        'lastname': lName.value,
        'pupName': pupName.value,
        // 'phoneNumber': number,
      };
      String imageName = '';

      imageName = "${fName.value}, ${lName.value}, ${pupName.value}";
      // imageName = "${fName.value}, ${lName.value}, ${pupName.value}, $number";
      setValue(kqrcode, imageName);

      setValue(kSelectedModel, model);
      setValue(kFirstName, fName.value);
      setValue(kLastName, lName.value);
      items.add(model.toString());
      await prefs.setStringList(kList, items);
      setValue(kIsLoggedIn, true);
      emitSuccess();
    } catch (e) {
      emitFailure(failureResponse: '$e');
    }
  }
}
