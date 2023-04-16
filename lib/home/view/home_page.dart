import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart' hide AppButton;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrcode_app/router.dart';
import 'package:qrcode_app/util/color.dart';
import 'package:qrcode_app/util/constant.dart';

import '../../gen/assets.gen.dart';
import '../../util/app_button.dart';
import '../provider/provider.dart';

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedModel =
        useState(getStringAsync(kSelectedModel, defaultValue: "unkown"));

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return SafeArea(
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        drawer: Drawer(
          child: Container(
            color: kPrimaryColor,
            padding: const EdgeInsets.all(20),
            child: ListView(shrinkWrap: true, children: [
              50.height,
              Text(
                'Your Dogs',
                textAlign: TextAlign.center,
                style: GoogleFonts.ubuntu(
                    fontSize: 20, color: appBlack, fontWeight: FontWeight.w700),
              ),
              20.height,
              ref.watch(listUserProvider).when(
                  data: (data) {
                    return ListView(
                        shrinkWrap: true,
                        children: data
                            .map((e) => GestureDetector(
                                onTap: () {
                                  //  String value = e.toString();
                                  String fName = e.firstname!;
                                  String lName = e.lastname!;
                                  String phNum = e.phoneNumber!;
                                  String pupName = e.pupName!;
                                  var all = {
                                    'firstName': fName,
                                    'lastName': lName,
                                    'phoneNumber': phNum,
                                    'pupName': pupName
                                  };

                                  selectedModel.value = json.encode(all);
                                  finish(context);
                                },
                                child: ListTile(
                                  title: Text(e.pupName!),
                                )))
                            .toList());
                  },
                  error: (_, __) => const Center(
                        child: Text('An error occurred'),
                      ),
                  loading: () => const Center(
                        child: CircularProgressIndicator(),
                      )),
              const Divider(),
              SizedBox(
                width: context.width() / 3,
                child: AppButton(
                  title: "Add Another Dog(s)",
                  onPressed: () {
                    context.go(signUpRoute);
                  },
                  isDisabled: false,
                ),
              )
            ]),
          ),
        ),
        appBar: AppBar(
            backgroundColor: kPrimaryColor,
            leading: Builder(builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: appBlack,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            })),
        body: Column(
          children: <Widget>[
            80.height,
            Assets.image.dog
                .image(
                  width: 120,
                )
                .center(),
            10.height,
            Text(
              jsonDecode(selectedModel.value)['pupName'],
              textAlign: TextAlign.center,
              style: GoogleFonts.ubuntu(
                  fontSize: 20, color: appBlack, fontWeight: FontWeight.w700),
            ),
            48.height,
            Container(
              color: Colors.white,
              child: QrImage(
                data: selectedModel.value,
                size: 280,
                // You can include embeddedImageStyle Property if you
                //wanna embed an image from your Asset folder
                embeddedImageStyle: QrEmbeddedImageStyle(
                  size: const Size(
                    100,
                    100,
                  ),
                ),
              ),
            ),
            TextButton(
                onPressed: () {
                  context.go(loginRoute);
                  // context.replaceRoute(SignupRoute());
                },
                child: const Text(
                  'Log out',
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.yellow,
                      fontWeight: FontWeight.bold),
                ))
          ],
        ),
      ),
    );
  }
}
