import 'dart:async';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:nb_utils/nb_utils.dart' hide AppButton;
import 'package:path_provider/path_provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:qrcode_app/router.dart';
import 'package:qrcode_app/util/color.dart';

import '../../gen/assets.gen.dart';
import '../../home/provider/provider.dart';
import '../../util/app_button.dart';
import '../../util/constant.dart';
import '../../util/input_decoration.dart';
import '../../util/loader.dart';
import '../bloc/register_form_bloc.dart';

class RegisterPage extends ConsumerWidget {
  String policyPDF = "";
  String conditionPDF = "";

  RegisterPage({Key? key}) : super(key: key) {
    fromAsset('asset/Privacy_Policy.pdf', 'Privacy_Policy.pdf').then((f) {
      policyPDF = f.path;
    });
    fromAsset('asset/Terms_and_Conditions.pdf', 'Terms_and_Conditions.pdf')
        .then((f) {
      conditionPDF = f.path;
    });
  }
  Future<File> fromAsset(String asset, String filename) async {
    Completer<File> completer = Completer();
    try {
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  void navigateToTermsAndConditions(BuildContext context) {
    if (conditionPDF.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFScreen(path: conditionPDF),
        ),
      );
    }
  }

  Future<void> navigateToPrivacyPolicy(BuildContext context) async {
    if (policyPDF.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFScreen(path: policyPDF),
        ),
      );
    }
    /*  try {
                                      _launchUrl(context,
                                          "https://vigoplace.com/terms-and-conditions");
                                      /*      await launch('https://flutter.dev',
                                          forceWebView: true,
                                          //   forceSafariVC: true,
                                          enableJavaScript: true); */
                                    } catch (e) {
                                      log('invalid url');
                                    } */
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BlocProvider(
      create: (context) => SignupFormBloc(),
      child: Builder(builder: (context) {
        final signupFormBloc = context.read<SignupFormBloc>();
        // String phoneNumber = getStringAsync(kPhoneNumber, defaultValue: '');
        // if (!phoneNumber.trim().isEmptyOrNull) {
        //   signupFormBloc.numberCode.updateValue(true);
        // }

        String lastName = getStringAsync(kLastName, defaultValue: '');
        if (!lastName.trim().isEmptyOrNull) {
          signupFormBloc.lName
              .updateValue(getStringAsync(kLastName, defaultValue: ''));
        }

        String firstName = getStringAsync(kFirstName, defaultValue: '');
        if (!firstName.trim().isEmptyOrNull) {
          signupFormBloc.fName
              .updateValue(getStringAsync(kFirstName, defaultValue: ''));
          signupFormBloc.agreeToConditions.updateValue(true);
        }

        return Scaffold(
            backgroundColor: kPrimaryColor,
            body: SafeArea(
              child: FormBlocListener<SignupFormBloc, String, String>(
                onSubmitting: (context, state) {
                  showLoader(context);
                },
                onSuccess: (context, state) {
                  hideLoader();
                  context.pushReplacement(homeRoute);
                  ref.refresh(listUserProvider);
                  /*  snackBar(context,
                  title: 'Account Created Successful',
                  backgroundColor: Colors.green);
              ref.refresh(feedNotifierProvider);
              ref.refresh(avatarProvider);
              //  context.navigateTo(DashboardRoute(children: [ExploreRouter()]));
              // ref.refresh(feedNotifierProvider);
              context.replaceRoute(DashboardRoute()); */
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

                      /*  Assets.logo.logoDark
                      .image(
                        width: 120,
                      )
                      .center(), */
                      // 48.height,
                      // Text(
                      //   phoneNumber.isEmptyOrNull
                      //       ? 'Please enter your information below'
                      //       : 'Please enter your dog name',
                      //   textAlign: TextAlign.center,
                      //   style:
                      //       GoogleFonts.ubuntu(fontSize: 20, color: appBlack),
                      // ),
                      32.height,
                      Visibility(
                        visible: firstName.trim().isEmptyOrNull,
                        child: TextFieldBlocBuilder(
                          textFieldBloc: signupFormBloc.fName,
                          decoration: inputDecoration(
                              labelText: 'First Name',
                              prefixIcon: const Icon(PhosphorIcons.user)),
                        ),
                      ),
                      Visibility(
                        visible: lastName.trim().isEmptyOrNull,
                        child: TextFieldBlocBuilder(
                          textFieldBloc: signupFormBloc.lName,
                          decoration: inputDecoration(
                              labelText: 'Last Name',
                              prefixIcon: const Icon(PhosphorIcons.user)),
                        ),
                      ),
                      TextFieldBlocBuilder(
                        textFieldBloc: signupFormBloc.pupName,
                        decoration: inputDecoration(
                            labelText: "Pup's Name(s)",
                            prefixIcon: const Icon(PhosphorIcons.dog)),
                      ),
                      // Visibility(
                      //   visible: phoneNumber.trim().isEmptyOrNull,
                      //   child: IntlPhoneField(
                      //     decoration: inputDecoration(
                      //       labelText: 'Phone Number',
                      //     ),
                      //     initialCountryCode: 'US',
                      //     onChanged: (phone) {
                      //       print(phone.completeNumber);
                      //       if (phone.completeNumber.toString().isEmptyOrNull ||
                      //           phone.completeNumber.length < 3) {
                      //         signupFormBloc.numberCode.updateValue(false);
                      //       } else {
                      //         signupFormBloc.numberCode.updateValue(true);
                      //       }
                      //       setValue(
                      //           kPhoneNumber, phone.completeNumber.toString());
                      //     },
                      //   ),
                      // ),
                      /*  TextFieldBlocBuilder(
                        textFieldBloc: signupFormBloc.confirmPassword,
                        suffixButton: SuffixButton.obscureText,
                        obscureTextFalseIcon: const Icon(PhosphorIcons.eye),
                        obscureTextTrueIcon: const Icon(PhosphorIcons.eyeSlash),
                        decoration: inputDecoration(
                          labelText: 'Confirm Password',
                          prefixIcon: const Icon(PhosphorIcons.lock),
                        ),
                      ), */
                      20.height,
                      Visibility(
                        // visible: phoneNumber.trim().isEmptyOrNull,
                        visible: true,
                        child: CheckboxFieldBlocBuilder(
                          //   checkColor:
                          //     MaterialStateProperty.all(ColorName.primaryColor),
                          booleanFieldBloc: signupFormBloc.agreeToConditions,
                          body: RichText(
                            overflow: TextOverflow.ellipsis,

                            // maxLines: 1,
                            text: TextSpan(
                              text: 'I agree to the ',
                              style: const TextStyle(
                                  color: appBlack, height: 1.5, fontSize: 14.0),
                              children: [
                                TextSpan(
                                    text: 'Terms And Conditions',
                                    style: const TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () =>
                                          navigateToTermsAndConditions(
                                              context)),
                                const TextSpan(
                                  text: ' and \n',
                                ),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap =
                                        () => navigateToPrivacyPolicy(context),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      20.height,
                      BlocBuilder<SignupFormBloc, FormBlocState>(
                        builder: (context, FormBlocState state) {
                          return BlocBuilder<BooleanFieldBloc, dynamic>(
                              bloc: signupFormBloc.agreeToConditions,
                              builder: (context, s) {
                                return AppButton(
                                  title:
                                      // phoneNumber.isEmptyOrNull
                                      //     ? 'Create Account'
                                      //
                                      //     :
                                      'Add Dog',
                                  onPressed: signupFormBloc.submit,
                                  isDisabled:
                                      state.isValid(0) && s.value == true
                                          ? false
                                          : true,
                                  /*  isDisabled:
                                signupFormBloc.agreeToConditions.value == true
                                    ? false
                                    : true, */
                                );
                              });
                        },
                      ),
                      24.height,
                      // Visibility(
                      //   visible: phoneNumber.isEmptyOrNull,
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       const Text('Already have an account?',
                      //           style: TextStyle(fontSize: 16.0)),
                      //       GestureDetector(
                      //         onTap: () {
                      //           context.go(loginRoute);
                      //           // context.replaceRoute(SignupRoute());
                      //         },
                      //         child: const Text(
                      //           ' Login',
                      //           style: TextStyle(
                      //               fontSize: 16.0,
                      //               color: Colors.blue,
                      //               fontWeight: FontWeight.bold),
                      //         ),
                      //       )
                      //     ],
                      //   ),
                      // )
                    ],
                  ),
                ),
              ),
            ));
      }),
    );
  }

  // void _launchUrl(BuildContext context, String url) async {
  //   // final Uri _url = Uri.parse(url);
  //   if (!await urlLauncher.launch(url)) {
  //     snackBar(context,
  //         title: 'Unable to lunch Url', backgroundColor: Colors.red);
  //   }
  // }
}

class PDFScreen extends StatefulWidget {
  final String? path;

  PDFScreen({Key? key, this.path}) : super(key: key);

  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(""),
      ),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.path,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: false,
            pageFling: true,
            pageSnap: true,
            defaultPage: currentPage!,
            fitPolicy: FitPolicy.BOTH,
            preventLinkNavigation:
                false, // if set to true the link is handled in flutter
            onRender: (_pages) {
              setState(() {
                pages = _pages;
                isReady = true;
              });
            },
            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
              print(error.toString());
            },
            onPageError: (page, error) {
              setState(() {
                errorMessage = '$page: ${error.toString()}';
              });
              print('$page: ${error.toString()}');
            },
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            },
            onLinkHandler: (String? uri) {
              print('goto uri: $uri');
            },
            onPageChanged: (int? page, int? total) {
              print('page change: $page/$total');
              setState(() {
                currentPage = page;
              });
            },
          ),
          errorMessage.isEmpty
              ? !isReady
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container()
              : Center(
                  child: Text(errorMessage),
                )
        ],
      ),
      floatingActionButton: FutureBuilder<PDFViewController>(
        future: _controller.future,
        builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
          if (snapshot.hasData) {
            return FloatingActionButton.extended(
              label: Text("Go to ${pages! ~/ 2}"),
              onPressed: () async {
                await snapshot.data!.setPage(pages! ~/ 2);
              },
            );
          }

          return Container();
        },
      ),
    );
  }
}
