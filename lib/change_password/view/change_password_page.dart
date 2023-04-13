import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:nb_utils/nb_utils.dart' hide AppButton;
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:qrcode_app/router.dart';
import 'package:qrcode_app/util/color.dart';

import '../../gen/assets.gen.dart';
import '../../util/app_button.dart';
import '../../util/constant.dart';
import '../../util/input_decoration.dart';
import '../../util/loader.dart';
import '../bloc/change_password_bloc.dart';

class ChangePasswordPage extends ConsumerWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BlocProvider(
      create: (context) => ChangePassFormBloc(),
      child: Builder(builder: (context) {
        final loginFormBloc = context.read<ChangePassFormBloc>();
        loginFormBloc.username.updateValue(getStringAsync(kEmail));
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
              backgroundColor: kPrimaryColor,
              body: SafeArea(
                child: FormBlocListener<ChangePassFormBloc, String, String>(
                  onSubmitting: (context, state) {
                    showLoader(context);
                  },
                  onSuccess: (context, state) {
                    context.go(homeRoute);
                  },
                  onFailure: (context, state) {
                    //   print('failure ${state.failureResponse!}');
                    //   LoadingDialog.hide(context);
                    hideLoader();
                    snackBar(context,
                        title: state.failureResponse!,
                        backgroundColor: Colors.red);
                  },
                  child: AutofillGroup(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 24.0),
                      children: [
                        Assets.image.dog
                            .image(
                              width: 120,
                            )
                            .center(),

                        48.height,
                        Text(
                          'Please log in to your account to access unique QR code!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.ubuntu(
                              fontSize: 20,
                              color: appBlack,
                              fontWeight: FontWeight.w700),
                        ),
                        32.height,
                        TextFieldBlocBuilder(
                          textFieldBloc: loginFormBloc.username,
                          decoration: inputDecoration(
                              labelText: 'Gmail',
                              prefixIcon: const Icon(PhosphorIcons.user)),
                        ),

                        TextFieldBlocBuilder(
                          textFieldBloc: loginFormBloc.oldPassword,
                          suffixButton: SuffixButton.obscureText,
                          obscureTextFalseIcon: const Icon(PhosphorIcons.eye),
                          obscureTextTrueIcon:
                              const Icon(PhosphorIcons.eyeSlash),
                          decoration: inputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(PhosphorIcons.lock),
                            //     suffixIcon: Icon(PhosphorIcons.eyeSlash),
                          ),
                        ),

                        12.height,
                        TextFieldBlocBuilder(
                          textFieldBloc: loginFormBloc.currentPassword,
                          suffixButton: SuffixButton.obscureText,
                          obscureTextFalseIcon: const Icon(PhosphorIcons.eye),
                          obscureTextTrueIcon:
                              const Icon(PhosphorIcons.eyeSlash),
                          decoration: inputDecoration(
                            labelText: 'new Password',
                            prefixIcon: const Icon(PhosphorIcons.lock),
                            //     suffixIcon: Icon(PhosphorIcons.eyeSlash),
                          ),
                        ),
                        /*Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          child: Text('Forgot Password?'),
                          onPressed: () => null,
                        )
                      ],
                    ), */
                        const Align(
                          alignment: Alignment.bottomRight,
                          child: Text('Change password',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.yellow,
                                  fontWeight: FontWeight.bold)),
                        ),
                        20.height,
                        BlocBuilder<ChangePassFormBloc, FormBlocState>(
                          bloc: loginFormBloc,
                          builder: (context, FormBlocState state) {
                            return AppButton(
                              title: 'Login',
                              onPressed: loginFormBloc.submit,
                              isDisabled: state.isValid(0) ? false : true,
                            );
                          },
                        ),
                        24.height,
                        /*   Text(
                          'OR LOGIN WITH',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12.0, color: ColorName.black40),
                        ), */
                        //  72.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Don\'t have an account yet?',
                                style: TextStyle(fontSize: 16.0)),
                            TextButton(
                                onPressed: () {
                                  // context.replaceRoute(SignupRoute());
                                },
                                child: const Text(
                                  'Sign up',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.yellow,
                                      fontWeight: FontWeight.bold),
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )),
        );
      }),
    );
  }
}
