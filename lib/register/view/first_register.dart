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
import '../../util/input_decoration.dart';
import '../../util/loader.dart';
import '../bloc/first_register_bloc.dart';

class FirstRegisterPage extends ConsumerWidget {
  const FirstRegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BlocProvider(
      create: (context) => FirstFormBloc(),
      child: Builder(builder: (context) {
        final loginFormBloc = context.read<FirstFormBloc>();
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
              backgroundColor: kPrimaryColor,
              body: SafeArea(
                child: FormBlocListener<FirstFormBloc, String, String>(
                  onSubmitting: (context, state) {
                    showLoader(context);
                  },
                  onSuccess: (context, state) {
                    hideLoader();
                    context.go(signUpRoute);
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
                          'Please enter your information below',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.ubuntu(
                              fontSize: 16,
                              color: appBlack,
                              fontWeight: FontWeight.w700),
                        ),
                        32.height,
                        TextFieldBlocBuilder(
                          textFieldBloc: loginFormBloc.username,
                          decoration: inputDecoration(
                              labelText: 'Email',
                              prefixIcon: const Icon(PhosphorIcons.user)),
                        ),

                        TextFieldBlocBuilder(
                          textFieldBloc: loginFormBloc.password,
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
                        /*Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          child: Text('Forgot Password?'),
                          onPressed: () => null,
                        )
                      ],
                    ), */
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(),
                            const Text('Already have an Account?',
                                style: TextStyle(fontSize: 16.0)),
                            GestureDetector(
                              onTap: () {
                                context.go(fsignUpRoute);
                                // context.replaceRoute(SignupRoute());
                              },
                              child: const Text(
                                ' Log in',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.yellow,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                            /*  TextButton(
                                onPressed: () {
                                  // context.replaceRoute(SignupRoute());
                                  context.go(loginRoute);
                                },
                                child: const Text(
                                  'Log in',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.yellow,
                                      fontWeight: FontWeight.bold),
                                )) */
                          ],
                        ),
                        20.height,
                        BlocBuilder<FirstFormBloc, FormBlocState>(
                          bloc: loginFormBloc,
                          builder: (context, FormBlocState state) {
                            return AppButton(
                              title: 'Create Account',
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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('By clicking "Create page" you agree to our',
                                style: TextStyle(fontSize: 16.0)),
                            Text(
                              'Privacy policy and Terms',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.yellow,
                                  fontWeight: FontWeight.bold),
                            )
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
