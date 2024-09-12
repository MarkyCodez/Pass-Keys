import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/common/alter_site_name.dart';
import 'package:password_manager/database/database_provider.dart';
import 'package:password_manager/widgets/my_snack_bar.dart';
import 'package:password_manager/widgets/my_text_button.dart';
import 'package:password_manager/widgets/show_password_container.dart';
import 'package:provider/provider.dart';

class DesktopViewPasswordsPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) {
        return const DesktopViewPasswordsPage();
      });
  const DesktopViewPasswordsPage({super.key});

  @override
  State<DesktopViewPasswordsPage> createState() => _ViewPasswordsPageState();
}

class _ViewPasswordsPageState extends State<DesktopViewPasswordsPage> {
  late final _databaseListener = Provider.of<DatabaseProvider>(context);
  late final _databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  Future<void> loadPass() async {
    await _databaseProvider.loadPassword();
  }

  TextStyle textStyle = const TextStyle(
    fontSize: 15.0,
  );

  final TextEditingController _updateSite = TextEditingController();
  final TextEditingController _updateUserName = TextEditingController();
  final TextEditingController _updatePassword = TextEditingController();
  final TextEditingController _updateNote = TextEditingController();
  final TextEditingController _checkController = TextEditingController();

  Future<void> _updatePass(
    int id,
    String site,
    userName,
    passWord,
    Note,
  ) async {
    await _databaseProvider.updatePass(
      id,
      site,
      userName,
      passWord,
      Note,
    );
    await loadPass();
  }

  Future<void> _getPinCode() async {
    await _databaseProvider.getPinCode();
  }

  late bool f2;

  void checkPinCode(String pinCode) {
    if (pinCode == _checkController.text.trim() &&
        _checkController.text.isNotEmpty) {
      setState(() {
        f2 = true;
      });
    } else {
      setState(() {
        f2 = false;
      });
    }
  }

  void showPinCode(String pinCode) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: TextField(
            controller: _checkController,
            decoration: InputDecoration(
              labelText: 'Enter Pin Code',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          actions: [
            MyTextButton(
              text: 'Verify',
              onTap: () {
                checkPinCode(pinCode);
                mySnackBar(context, 'Pin Code Verified');
                if (f2 == false) {
                  mySnackBar(context, 'Invalid Pin Code');
                }
                _checkController.clear();
                Navigator.pop(context);
              },
            ),
            MyTextButton(
              text: 'Cancel',
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void showPassword(
    int id,
    String site,
    userName,
    passWord,
    Note,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          content: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Site',
                  style: textStyle,
                ),
                ShowPasswordContainer(
                  site: site,
                  control: _updateSite,
                ),
                Text(
                  'User Name',
                  style: textStyle,
                ),
                ShowPasswordContainer(
                  site: userName,
                  control: _updateUserName,
                ),
                Text(
                  'Password',
                  style: textStyle,
                ),
                ShowPasswordContainer(
                  site: passWord,
                  control: _updatePassword,
                ),
                Text(
                  'Note',
                  style: textStyle,
                ),
                ShowPasswordContainer(
                  site: Note,
                  control: _updateNote,
                ),
              ],
            ),
          ),
          actions: [
            MyTextButton(
              text: 'Update',
              onTap: () {
                _updatePass(
                  id,
                  _updateSite.text.trim(),
                  _updateUserName.text.trim(),
                  _updatePassword.text.trim(),
                  _updateNote.text.trim(),
                );
                setState(() {
                  f2 = false;
                });
                Navigator.pop(context);
              },
            ),
            MyTextButton(
              text: 'Cancel',
              onTap: () {
                setState(() {
                  f2 = false;
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> deletePass(int id) async {
    await _databaseProvider.deletePass(id);
  }

  @override
  void initState() {
    loadPass();
    _getPinCode();
    setState(() {
      f2 = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final passwords = _databaseListener.getPass;
    final List<Map<String, dynamic>> pins = _databaseListener.getPins;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text('Passwords'),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: passwords.length,
              (_, index) {
                final pass = passwords[index];
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListTile(
                    onLongPress: () async {
                      await deletePass(pass.id ?? 0);
                    },
                    trailing: GestureDetector(
                      onTap: () {
                        if (pins.isEmpty || f2 == true) {
                          showPassword(
                            pass.id ?? 0,
                            pass.site,
                            pass.username,
                            pass.password,
                            pass.note,
                          );
                        } else {
                          showPinCode(pins[0]['pin_code']);
                        }
                      },
                      child: const Icon(
                        CupertinoIcons.eye_slash_fill,
                      ),
                    ),
                    onTap: () {},
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    tileColor: Theme.of(context).colorScheme.secondary,
                    title: Text(
                      alterSiteName(
                        pass.site,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
