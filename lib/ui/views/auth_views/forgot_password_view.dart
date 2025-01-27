import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../../config/constants.dart';
import '../../../logic/providers/providers.dart';
import '../../widgets/auth_field_widget.dart';

class ForgotPasswordView extends ConsumerStatefulWidget {
  /// UI for resetting password

  const ForgotPasswordView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ForgotPasswordViewWidgetState();
}

class _ForgotPasswordViewWidgetState extends ConsumerState<ForgotPasswordView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.read(authentication);
    final mediaWidth = MediaQuery.sizeOf(context).width;
    final urlLauncher = ref.read(url);
    final isDarkMode = ref.watch(darkMode);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        // back button
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? white : black,
          ),
          onPressed: () async {
            await clicker.setAsset('assets/click.mov');
            clicker.play();
            // ignore: use_build_context_synchronously
            Beamer.of(context).beamToNamed('/sign-in');
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Receive an email to\nreset your password',
                style: isDarkMode ? darkModeLargeFont : lightModeLargeFont,
                textAlign: TextAlign.center,
              ),
              gapH20,
              AuthFieldWidget(
                textController: _emailController,
                obscurePassword: false,
                hintText: 'Email',
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
                      await auth.resetPassword(
                        email: _emailController.text.trim(),
                      );
                      // Pop loading dialog
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      showMessage(
                        'Check your email to reset your password',
                        // ignore: use_build_context_synchronously
                        context,
                        isDarkMode,
                      );
                    } catch (e) {
                      // Pop loading dialog
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      // ignore: use_build_context_synchronously
                      showMessage(e.toString(), context, isDarkMode);
                    }
                  },
                  child: Text(
                    'Reset Password',
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
                  style: isDarkMode ? darkModeSmallFont : lightModeSmallFont,
                ),
              ),
              gapH10,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
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
        ),
      ),
    );
  }
}
