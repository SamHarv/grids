import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ForgotPasswordPageWidgetState();
}

class _ForgotPasswordPageWidgetState extends ConsumerState<ForgotPasswordPage> {
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
    final auth = ref.read(firebaseAuth);
    final mediaWidth = MediaQuery.of(context).size.width;
    final isDarkMode = ref.watch(darkMode);

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
                style: isDarkMode ? darkLargeFont : lightLargeFont,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              LoginFieldWidget(
                textController: _emailController,
                obscurePassword: false,
                hintText: 'Email',
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
                      await auth.resetPassword(
                        email: _emailController.text.trim(),
                      );
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      showMessage('Check your email to reset your password');
                    } catch (e) {
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      showMessage(e.toString());
                    }
                  },
                  child: Text(
                    'Reset Password',
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
                      _launchUrl();
                    }),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
