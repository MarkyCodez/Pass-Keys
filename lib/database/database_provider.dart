import 'package:flutter/material.dart';
import 'package:password_manager/database/sql_helper.dart';
import 'package:password_manager/model/password_model.dart';

class DatabaseProvider extends ChangeNotifier {
  final sqlClient = SqlHelper();

  Future<int> addPass(
    String siteParam,
    usernameParam,
    passwordParam,
    noteParam,
  ) async {
    final res = await sqlClient.addPassword(
      siteParam,
      usernameParam,
      passwordParam,
      noteParam,
    );
    await loadPassword();
    return res;
  }

  List<PasswordModel> _passwords = [];

  List<PasswordModel> get getPass => _passwords;

  Future<void> loadPassword() async {
    _passwords = await sqlClient.getPasswords();
    notifyListeners();
  }

  Future<void> updatePass(
    int id,
    String siteParam,
    usernameParam,
    passwordParam,
    noteParam,
  ) async {
    sqlClient.updatePasswords(
      id,
      siteParam,
      usernameParam,
      passwordParam,
      noteParam,
    );
    await loadPassword();
  }

  Future<void> deletePass(int id) async {
    await sqlClient.deletePasswords(id);
    await loadPassword();
  }

  Future<void> addPinCode(String pinCode) async {
    await sqlClient.addPin(pinCode);
    await getPinCode();
  }

  List<Map<String, dynamic>> _allPins = [];

  List<Map<String, dynamic>> get getPins => _allPins;

  Future<void> getPinCode() async {
    final res = await sqlClient.getPin();
    _allPins = res;
    notifyListeners();
  }

  Future<void> updatePinCode(int id, String newPinCode) async {
    await sqlClient.updatePin(id, newPinCode);
    await getPinCode();
  }

  Future<void> deletePinCode(int id) async {
    await sqlClient.deletePin(id);
    await getPinCode();
  }
}
