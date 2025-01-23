import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:just_audio/just_audio.dart';

import '/controller/constants/constants.dart';
import '/controller/state_management/providers.dart';
import '/data/model/user_model.dart';
import '../../widgets/login_field_widget.dart';

final _url = Uri.parse('https://oxygentech.com.au');

Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw 'Could not launch $_url';
  }
}

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  late AudioPlayer clicker = AudioPlayer();

  @override
  void initState() {
    clicker = AudioPlayer();
    super.initState();
  }

  @override
  void dispose() {
    clicker.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.read(firestore);
    final auth = ref.read(firebaseAuth);
    final isDarkMode = ref.watch(darkMode);
    final validate = ref.watch(validation);
    final logo = isDarkMode ? 'images/grids.png' : 'images/grids_light.png';
    final mediaWidth = MediaQuery.of(context).size.width;

    void showMessage(String message) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: isDarkMode ? Colors.black : Colors.white,
            title: Center(
              child: Text(
                message,
                style: isDarkMode ? darkLargeFont : lightLargeFont,
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(height: 60),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Image.asset(
                    logo,
                    width: mediaWidth * 0.75,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                children: [
                  LoginFieldWidget(
                    textController: _nameController,
                    obscurePassword: false,
                    hintText: 'Name',
                    mediaWidth: mediaWidth,
                  ),
                  const SizedBox(height: 10),
                  LoginFieldWidget(
                    textController: _emailController,
                    obscurePassword: false,
                    hintText: 'Email',
                    mediaWidth: mediaWidth,
                  ),
                  const SizedBox(height: 10),
                  LoginFieldWidget(
                    textController: _passwordController,
                    obscurePassword: true,
                    hintText: 'Password',
                    mediaWidth: mediaWidth,
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: mediaWidth * 0.8,
                    height: 60,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                          isDarkMode ? white : black,
                        ),
                      ),
                      onPressed: () async {
                        await clicker.setAsset('assets/click.mov');
                        clicker.play();
                        showDialog(
                          // ignore: use_build_context_synchronously
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: isDarkMode ? white : black,
                              ),
                            );
                          },
                        );
                        try {
                          validate.validateName(_nameController.text.trim()) !=
                                  null
                              ? throw 'Name is required'
                              : null;
                          validate.validateEmail(
                                      _emailController.text.trim()) !=
                                  null
                              ? throw 'Email is invalid'
                              : null;
                          validate.validatePassword(
                                      _passwordController.text.trim()) !=
                                  null
                              ? throw 'Password must be at least 6 characters'
                              : null;
                          await auth.signUp(
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                          );
                          final user = UserModel(
                            id: auth.user!.uid,
                            email: _emailController.text.trim(),
                            name: _nameController.text.trim(),
                          );
                          await db.addUser(user: user);
                          //ignore: use_build_context_synchronously
                          Navigator.pop(context);
                          showMessage("User created!");
                          //ignore: use_build_context_synchronously
                          Beamer.of(context).beamToNamed('/grids');
                        } catch (e) {
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                          showMessage(e.toString());
                        }
                      },
                      child: Text(
                        'Sign Up',
                        style: isDarkMode ? lightFont : darkFont,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () async {
                      await clicker.setAsset('assets/click.mov');
                      clicker.play();
                      // ignore: use_build_context_synchronously
                      Beamer.of(context).beamToNamed('/sign-in');
                    },
                    child: Text(
                      'Sign In',
                      style: isDarkMode ? darkSmallFont : lightSmallFont,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    child: InkWell(
                        borderRadius: BorderRadius.circular(32),
                        child: Image.asset(
                          isDarkMode
                              ? 'images/o2tech_white.png'
                              : 'images/o2tech_black.png',
                          fit: BoxFit.contain,
                          height: 50,
                        ),
                        onTap: () async {
                          await clicker.setAsset('assets/click.mov');
                          clicker.play();
                          _launchUrl();
                        }),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
