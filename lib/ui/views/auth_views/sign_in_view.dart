import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:just_audio/just_audio.dart';

import '../../../config/constants.dart';
import '../../../logic/providers/providers.dart';
import '../../widgets/auth_field_widget.dart';

class SignInView extends ConsumerStatefulWidget {
  /// UI for signing in

  const SignInView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInViewState();
}

class _SignInViewState extends ConsumerState<SignInView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late SharedPreferences _prefs; // for dark/ light mode
  late AudioPlayer clicker = AudioPlayer();

  @override
  void initState() {
    clicker = AudioPlayer();
    _initSharedPreferences();
    super.initState();
  }

  /// Initialise shared preferences
  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _loadDarkMode();
  }

  /// Load dark/ light mode from shared preferences
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
    final mediaWidth = MediaQuery.sizeOf(context).width;
    final auth = ref.read(authentication);
    final isDarkMode = ref.watch(darkMode);
    final logo = isDarkMode ? 'images/grids.png' : 'images/grids_light.png';
    final urlLauncher = ref.read(url);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // grids. logo
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
                  AuthFieldWidget(
                    textController: _emailController,
                    obscurePassword: false,
                    hintText: 'Email',
                    mediaWidth: mediaWidth,
                  ),
                  gapH10,
                  AuthFieldWidget(
                    textController: _passwordController,
                    obscurePassword: true,
                    hintText: 'Password',
                    mediaWidth: mediaWidth,
                  ),
                  gapH10,
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
                        // Show loading dialog
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
                          // Pop loading dialog
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                          // ignore: use_build_context_synchronously
                          showMessage("User signed in!", context, isDarkMode);

                          // ignore: use_build_context_synchronously
                          Beamer.of(context).beamToNamed('/grids');
                        } catch (e) {
                          // Pop loading dialog
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                          // ignore: use_build_context_synchronously
                          showMessage(e.toString(), context, isDarkMode);
                        }
                      },
                      child: Text(
                        'Sign In',
                        style: isDarkMode ? lightModeFont : darkModeFont,
                      ),
                    ),
                  ),
                  gapH10,
                  TextButton(
                    onPressed: () async {
                      await clicker.setAsset('assets/click.mov');
                      clicker.play();
                      // ignore: use_build_context_synchronously
                      Beamer.of(context).beamToNamed('/sign-up');
                    },
                    child: Text(
                      'Sign Up',
                      style:
                          isDarkMode ? darkModeSmallFont : lightModeSmallFont,
                    ),
                  ),
                  gapH10,
                  TextButton(
                    onPressed: () async {
                      await clicker.setAsset('assets/click.mov');
                      clicker.play();
                      // ignore: use_build_context_synchronously
                      Beamer.of(context).beamToNamed('/forgot-password');
                    },
                    child: Text(
                      'Forgot Password',
                      style:
                          isDarkMode ? darkModeSmallFont : lightModeSmallFont,
                    ),
                  ),
                  gapH10,
                  // O2Tech logo to launch O2Tech website
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
                        urlLauncher.launchO2Tech();
                      },
                    ),
                  ),
                  gapH20,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
