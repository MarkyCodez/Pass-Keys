import 'package:flutter/material.dart';
import 'package:password_manager/database/database_provider.dart';
import 'package:password_manager/widgets/my_button.dart';
import 'package:password_manager/widgets/my_pin_button.dart';
import 'package:password_manager/widgets/my_snack_bar.dart';
import 'package:provider/provider.dart';

class DesktopSecurityPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) {
        return const DesktopSecurityPage();
      });
  const DesktopSecurityPage({super.key});

  @override
  State<DesktopSecurityPage> createState() => _SecurityKeyState();
}

class _SecurityKeyState extends State<DesktopSecurityPage> {
  late final _databaseProvider = Provider.of<DatabaseProvider>(
    context,
    listen: false,
  );
  late final _databaseListener = Provider.of<DatabaseProvider>(context);

  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _verifyController = TextEditingController();

  Future<void> addingPin() async {
    await _databaseProvider.addPinCode(_pinController.text.trim());
  }

  Future<void> gettingPin() async {
    await _databaseProvider.getPinCode();
  }

  Future<void> updatingPin(int id, String newPin) async {
    await _databaseProvider.updatePinCode(id, newPin);
  }

  Future<void> deletingPin(int id) async {
    await _databaseProvider.deletePinCode(id);
  }

  late bool f1;

  void verifyPin(String pinCode) {
    if (_verifyController.text.trim() == pinCode &&
        _verifyController.text.isNotEmpty) {
      setState(() {
        f1 = true;
      });
    } else {
      setState(() {
        f1 = false;
      });
    }
  }

  Widget pinButton(int len, int? id, String? pinCode) {
    if (!f1) {
      if (len == 0) {
        return MyPinButton(
          pinController: _pinController,
          text: 'Set Pin',
          buttonText: 'Set',
          onTap: () async {
            await addingPin();
            _pinController.clear();
          },
        );
      } else {
        return MyPinButton(
          pinController: _verifyController,
          text: 'Verify Pin',
          buttonText: 'Verify',
          onTap: () {
            verifyPin(pinCode!);

            if (f1 == false) {
              mySnackBar(context, 'Invalid Pin');
            }
            _verifyController.clear();
          },
        );
      }
    } else {
      return Column(
        children: [
          MyPinButton(
            pinController: _pinController,
            text: 'Update Pin',
            buttonText: 'Update',
            onTap: () async {
              if (id != null) {
                await updatingPin(id, _pinController.text.trim());
                setState(() {
                  f1 = false;
                });
              }

              _pinController.clear();
            },
          ),
          const SizedBox(
            height: 20,
          ),
          MyButton(
            onTap: () async {
              if (id != null) {
                await deletingPin(id);
                setState(() {
                  f1 = false;
                });
              }

              _pinController.clear();
            },
            text: 'Delete Pin',
          ),
        ],
      );
    }
  }

  @override
  void initState() {
    gettingPin();
    setState(() {
      f1 = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final m2 = _databaseListener.getPins;
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              textAlign: TextAlign.center,
              'Want to add a Security key?',
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: m2.isEmpty
                  ? pinButton(
                      m2.length,
                      null,
                      null,
                    )
                  : pinButton(
                      m2.length,
                      m2[0]['id'],
                      m2[0]['pin_code'],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
