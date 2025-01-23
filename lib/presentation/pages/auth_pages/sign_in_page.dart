import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:just_audio/just_audio.dart';

import '/controller/constants/constants.dart';
import '/controller/state_management/providers.dart';
import '../../widgets/login_field_widget.dart';

final _url = Uri.parse('https://oxygentech.com.au');

Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw 'Could not launch $_url';
  }
}

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late SharedPreferences _prefs;
  late AudioPlayer clicker = AudioPlayer();

  @override
  void initState() {
    clicker = AudioPlayer();
    _initSharedPreferences();
    super.initState();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _loadDarkMode();
  }

  void _loadDarkMode() {
    final isDarkMode = _prefs.getBool('darkMode') ?? true;
    ref.read(darkMode.notifier).state = isDarkMode;
  }

  @override
  void dispose() {
    clicker.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaWidth = MediaQuery.of(context).size.width;
    final auth = ref.read(firebaseAuth);
    final isDarkMode = ref.watch(darkMode);
    final logo = isDarkMode ? 'images/grids.png' : 'images/grids_light.png';

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
                          await auth.signIn(
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                          );
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                          showMessage("User signed in!");

                          // ignore: use_build_context_synchronously
                          Beamer.of(context).beamToNamed('/grids');
                        } catch (e) {
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                          showMessage(e.toString());
                        }
                      },
                      child: Text(
                        'Sign In',
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
                      Beamer.of(context).beamToNamed('/sign-up');
                    },
                    child: Text(
                      'Sign Up',
                      style: isDarkMode ? darkSmallFont : lightSmallFont,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () async {
                      await clicker.setAsset('assets/click.mov');
                      clicker.play();
                      // ignore: use_build_context_synchronously
                      Beamer.of(context).beamToNamed('/forgot-password');
                    },
                    child: Text(
                      'Forgot Password',
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
                      },
                    ),
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
