import 'package:freezed_annotation/freezed_annotation.dart';

// required: associates our `main.dart` with the code generated by Freezed
part 'user_data.freezed.dart';
// optional: Since our Person class is serializable, we must add this line.
// But if Person was not serializable, we could skip it.
part 'user_data.g.dart';

@unfreezed
class UserData with _$UserData {
  factory UserData({
    required String? firstname,
    required String? lastname,
    required String? phoneNumber,
    required String? pupName,
  }) = _UserModel;

  factory UserData.fromJson(Map<String, Object?> json) =>
      _$UserDataFromJson(json);
}
/* 
{"firstname":"john","lastname":"Aguda","phoneNumber":"07010261589","emailAddress":"near Santa "} */