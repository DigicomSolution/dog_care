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
                                  selectedModel.value = e.toJson().toString();
                                },
                                child: ListTile(
                                  title: Text(e.firstname!),
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
                  title: 'Add Another Dog',
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
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).

          children: <Widget>[
            100.height,
            Assets.image.dog
                .image(
                  width: 120,
                )
                .center(),
            10.height,
            Text(
              jsonDecode(selectedModel.value)['firstname'],
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
