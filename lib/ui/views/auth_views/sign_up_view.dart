import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../../config/constants.dart';
import '../../../logic/providers/providers.dart';
import '../../../data/models/user_model.dart';
import '../../widgets/auth_field_widget.dart';

class SignUpView extends ConsumerStatefulWidget {
  /// UI for signing up

  const SignUpView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpViewState();
}

class _SignUpViewState extends ConsumerState<SignUpView> {
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
    final auth = ref.read(authentication);
    final isDarkMode = ref.watch(darkMode);
    final validate = ref.watch(validation);
    final urlLauncher = ref.read(url);
    final logo = isDarkMode ? 'images/grids.png' : 'images/grids_light.png';
    final mediaWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Logo
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
                    textController: _nameController,
                    obscurePassword: false,
                    hintText: 'Name',
                    mediaWidth: mediaWidth,
                  ),
                  gapH10,
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
                          // Validate inputs
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
                          // Sign up
                          await auth.signUp(
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                          );
                          // Create user object
                          final user = UserModel(
                            id: auth.user!.uid,
                            email: _emailController.text.trim(),
                            name: _nameController.text.trim(),
                          );
                          // Add user to database
                          await db.addUser(user: user);
                          // Pop loading dialog
                          //ignore: use_build_context_synchronously
                          Navigator.pop(context);
                          // ignore: use_build_context_synchronously
                          showMessage("User created!", context, isDarkMode);
                          //ignore: use_build_context_synchronously
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
                        'Sign Up',
                        style: isDarkMode ? lightModeFont : darkModeFont,
                      ),
                    ),
                  ),
                  gapH20,
                  TextButton(
                    onPressed: () async {
                      await clicker.setAsset('assets/click.mov');
                      clicker.play();
                      // ignore: use_build_context_synchronously
                      Beamer.of(context).beamToNamed('/sign-in');
                    },
                    child: Text(
                      'Sign In',
                      style:
                          isDarkMode ? darkModeSmallFont : lightModeSmallFont,
                    ),
                  ),
                  gapH10,
                  // Logo to launch O2Tech website
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
                        }),
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
