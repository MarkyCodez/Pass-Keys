import 'package:flutter/material.dart';
import 'package:password_manager/database/database_provider.dart';
import 'package:password_manager/pages/desktop_pages/desktop_home_page.dart';
import 'package:password_manager/pages/security_key.dart';
import 'package:password_manager/pages/view_passwords_page.dart';
import 'package:password_manager/widgets/my_button.dart';
import 'package:password_manager/widgets/my_password_field.dart';
import 'package:password_manager/widgets/my_text_field.dart';
import 'package:password_manager/widgets/snack_bar.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 650) {
        return const DesktopHomePage();
      } else {
        return Scaffold(
          appBar: AppBar(
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(context, SecurityKey.route());
                  },
                  icon: Icon(
                    Icons.security,
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
                child: ListView(
                  children: [
                    const SizedBox(height: 70),
                    Center(
                      child: Text(
                        'Pass Keys',
                        style: TextStyle(
                          fontSize: 40.0,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
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
        );
      }
    });
  }
}
