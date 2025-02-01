import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:learn_flutter/data/models/user_model.dart';

class StorageService {
  static const String USER_KEY = 'user_data';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  Future<void> saveUser(UserModel user) async {
    try {
      final userData = {
        'data': {
          'user': user.toJson()['user'],
          'token': user.token,
        }
      };
      final jsonStr = jsonEncode(userData);
      print('Saving user data: $jsonStr');
      await _prefs.setString(USER_KEY, jsonStr);
    } catch (e) {
      print('Error saving user: $e');
    }
  }

  Future<void> removeUser() async {
    await _prefs.remove(USER_KEY);
  }

  UserModel? getUser() {
    try {
      final userStr = _prefs.getString(USER_KEY);
      print('Retrieved stored user string: $userStr');

      if (userStr != null) {
        final userData = jsonDecode(userStr);
        print('Decoded user data: $userData');

        final user = UserModel.fromJson(userData['data']);
        print('Parsed user model: ${user.toJson()}');
        return user;
      }
    } catch (e, stackTrace) {
      print('Error getting stored user: $e');
      print('Stack trace: $stackTrace');
    }
    return null;
  }
}
