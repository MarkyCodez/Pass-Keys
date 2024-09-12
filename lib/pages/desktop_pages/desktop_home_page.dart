import 'package:flutter/material.dart';
import 'package:password_manager/database/database_provider.dart';
import 'package:password_manager/pages/desktop_pages/desktop_security_page.dart';
import 'package:password_manager/pages/view_passwords_page.dart';
import 'package:password_manager/widgets/my_button.dart';
import 'package:password_manager/widgets/my_password_field.dart';
import 'package:password_manager/widgets/my_text_field.dart';
import 'package:password_manager/widgets/snack_bar.dart';
import 'package:provider/provider.dart';

class DesktopHomePage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) {
        return const DesktopHomePage();
      });
  const DesktopHomePage({super.key});

  @override
  State<DesktopHomePage> createState() => _HomePageState();
}

class _HomePageState extends State<DesktopHomePage> {
  late final _databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  final _siteController = TextEditingController();

  final _userNameController = TextEditingController();

  final _passwordController = TextEditingController();

  final _noteController = TextEditingController();

  late bool isEye;

  Future<void> add() async {
    await _databaseProvider.addPass(
      _siteController.text.trim(),
      _userNameController.text.trim(),
      _passwordController.text.trim(),
      _noteController.text.trim(),
    );
  }

  @override
  void initState() {
    isEye = true;
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _siteController.dispose();
    _userNameController.dispose();
    _passwordController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Text(
          'Pass Keys',
          style: TextStyle(
            fontSize: 40.0,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  DesktopSecurityPage.route(),
                );
              },
              icon: Icon(
                Icons.security,
                size: 35,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36.0),
          child: Form(
            key: _formKey,
            child: Center(
              child: SizedBox(
                width: 600,
                child: ListView(
                  children: [
                    const SizedBox(height: 150),
                    MyTextField(
                      hint: 'Website url',
                      controller: _siteController,
                    ),
                    const SizedBox(height: 20),
                    MyTextField(
                      hint: 'Username',
                      controller: _userNameController,
                    ),
                    const SizedBox(height: 20),
                    MyPasswordField(
                      controller: _passwordController,
                      hint: 'Password',
                      isObcure: isEye,
                      onPressed: () {
                        setState(() {
                          isEye = !isEye;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    MyTextField(
                      hint: 'Note',
                      maxLines: null,
                      maxLength: 400,
                      controller: _noteController,
                    ),
                    const SizedBox(height: 20),
                    MyButton(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            await add();
                            _siteController.clear();
                            _userNameController.clear();
                            _passwordController.clear();
                            _noteController.clear();
                            // ignore: use_build_context_synchronously
                            snackBar(context, 'Password Added Successfully');
                          }
                        },
                        text: 'Add Password'),
                    const SizedBox(height: 20),
                    MyButton(
                        onTap: () => Navigator.push(
                              context,
                              ViewPasswordsPage.route(),
                            ),
                        text: 'See Password'),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
