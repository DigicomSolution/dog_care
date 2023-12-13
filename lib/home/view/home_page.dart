import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart' hide AppButton;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrcode_app/data/model/user_data.dart';
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
        useState<UserData?>(UserData.fromJson(getJSONAsync(kSelectedModel)));
    //getStringAsync(kSelectedModel, defaultValue: "unkown")
    final qrImage = useState(getStringAsync(kqrcode, defaultValue: "unkown"));

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
                                  // String phNum = e.phoneNumber!;
                                  String pupName = e.pupName!;
                                  var all = {
                                    'firstName': fName,
                                    'lastName': lName,
                                    // 'phoneNumber': phNum,
                                    'pupName': pupName
                                  };
                                  String imageName =
                                      "${pupName.toUpperCase()} - $fName $lName"
                                      // " $phNum"
                                      ;
                                  setValue(kqrcode, imageName);
                                  qrImage.value = imageName;
                                  selectedModel.value = UserData.fromJson(all);
                                  finish(context);
                                },
                                child: ListTile(
                                  title: Text(
                                    "${e.pupName}",
                                    style: GoogleFonts.ubuntu(
                                        fontSize: 20,
                                        color: appBlack,
                                        fontWeight: FontWeight.w700),
                                  ),
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
                    context.push(signUpRoute);
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
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              40.height,
              Assets.image.dog
                  .image(
                    width: 120,
                  )
                  .center(),
              10.height,
              Text(
                selectedModel.value == null
                    ? 'No Dog '
                    : selectedModel.value!.pupName ?? 'No dog added',
                textAlign: TextAlign.center,
                style: GoogleFonts.ubuntu(
                    fontSize: 30, color: appBlack, fontWeight: FontWeight.w700),
              ),
              48.height,
              selectedModel.value != null
                  ? Container(
                      color: Colors.white,
                      child: QrImage(
                        data: qrImage.value,
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
                    )
                  : Container(),
              20.height,
              if (selectedModel.value != null)
                SizedBox(
                  width: 200,
                  child: AppButton(
                    title: 'Delete dog',
                    onPressed: () async {
                      bool confirmed = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirmation'),
                            content:
                                const Text('Are you sure you want to Delete?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(true); // Returns true when confirmed
                                },
                                child: const Text('Yes'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(
                                      false); // Returns false when canceled
                                },
                                child: const Text('No'),
                              ),
                            ],
                          );
                        },
                      );
                      if (confirmed != null && confirmed) {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();

                        final List<String> items =
                            prefs.getStringList(kList) ?? [];
                        String theOne = '';
                        for (String stuff in items) {
                          print(stuff);
                          //  print(jsonDecode(selectedModel.value)['pupName']);
                          if (stuff.contains(selectedModel.value!.pupName!)) {
                            theOne = stuff;
                          }
                        }
                        if (theOne.trim().isNotEmpty) {
                          items.remove(theOne);
                        }

                        // setValue(kSelectedModel, items);
                        // items.add(model.toString());

                        await prefs.setStringList(kList, items);
                        if (items.isEmpty) {
                          setValue(kSelectedModel, '');
                          selectedModel.value = null;
                          context.push(signUpRoute);
                        } else {
                          print('kkkkkk');
                          print(items[0]);
                          print(items[0]);
                          print('popopopoo');
                          //{firstname: j, lastname: j, pupName: pop new, phoneNumber: 19999999999}
                          var list = items[0].split(', ');
                          var fname = list[0].split('firstname:').last.trim();
                          var lname = list[1].split('lastname:').last.trim();
                          var pupName =
                              list[2].split(':').last.replaceAll('}', '');
                          // var phoneNumber =
                          //     list[3].split('phoneNumber:').last.trim();
                          var model = <String, String>{
                            'firstname': fname,
                            'lastname': lname,
                            'pupName': pupName,
                            // 'phoneNumber': phoneNumber,
                          };
                          setValue(kSelectedModel, model);
                          selectedModel.value = UserData(
                              firstname: fname,
                              lastname: lname,
                              // phoneNumber: phoneNumber,
                              pupName: pupName);
                          String imageName = '';

                          /*   String fname =
                            jsonDecode(selectedModel.value)['firstName'];
                        String lname =
                            jsonDecode(selectedModel.value)['lastName'];
                        String pname =
                            jsonDecode(selectedModel.value)['phoneNumber'];
                        String pupName =
                            jsonDecode(selectedModel.value)['pupName']; */
                          imageName = "${pupName.toUpperCase()} - $fname $lname"
                              // "$phoneNumber"
                              ;
                          print('wwer $imageName');
                          qrImage.value = imageName;
                          setValue(kqrcode, imageName);
                          ref.refresh(listUserProvider);
                        }
                      }
                    },
                    isDisabled: false,
                    /*  isDisabled:
                                    signupFormBloc.agreeToConditions.value == true
                                        ? false
                                        : true, */
                  ),
                ),
              if (selectedModel.value == null)
                SizedBox(
                  width: 200,
                  child: AppButton(
                    title: 'Add Another Dog(s)',
                    onPressed: () async {
                      context.push(signUpRoute);
                    },
                    isDisabled: false,
                    /*  isDisabled:
                                    signupFormBloc.agreeToConditions.value == true
                                        ? false
                                        : true, */
                  ),
                ),
              TextButton(
                  onPressed: () async {
                    bool confirmed = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Confirmation'),
                          content: Text('Are you sure you want to reset?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(true); // Returns true when confirmed
                              },
                              child: Text('Yes'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(false); // Returns false when canceled
                              },
                              child: Text('No'),
                            ),
                          ],
                        );
                      },
                    );
                    if (confirmed != null && confirmed) {
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      final List<String> items =
                          prefs.getStringList(kList) ?? [];
                      items.clear();
                      await prefs.setStringList(kList, items);
                      setValue(kLastName, '');
                      setValue(kFirstName, '');
                      setValue(kIsLoggedIn, false);

                      // context.go(fsignUpRoute);
                      context.go(signUpRoute);
                    }
                  },
                  child: const Text(
                    'Reset',
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
