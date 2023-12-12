import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qrcode_app/data/model/user_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/constant.dart';

final listUserProvider =
    FutureProvider.autoDispose<List<UserData>>((ref) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? list = prefs.getStringList(kList);
  print(list);
  List<UserData> userList = [];
  if (list != null) {
    if (list.isNotEmpty) {
      try {
        for (String host in list) {
          var string = host.split(',');
          var fisrtName = string[0].split(':').last;
          var lastName = string[1].split(':').last;
          var email = string[2].split(':').last.replaceAll('}', '');
          // var phone = string[3].split(':').last.split('}').first;

          userList.add(UserData(
              firstname: fisrtName,
              lastname: lastName,
              // phoneNumber: phone,
              pupName: email));
        }
      } catch (e) {
        print(e);
      }
    }
  }
  return userList;
});
