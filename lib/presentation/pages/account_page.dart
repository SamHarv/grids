import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:url_launcher/url_launcher.dart';

import '/controller/state_management/providers.dart';
import '/controller/constants/constants.dart';

final _url = Uri.parse('https://oxygentech.com.au');

Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw 'Could not launch $_url';
  }
}

class AccountPage extends ConsumerStatefulWidget {
  const AccountPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AccountPageWidgetState();
}

class _AccountPageWidgetState extends ConsumerState<AccountPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late AudioPlayer clicker = AudioPlayer();
  late AudioPlayer whoosh = AudioPlayer();

  @override
  void initState() {
    clicker = AudioPlayer();
    whoosh = AudioPlayer();
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
    final db = ref.read(firestore);
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
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () async {
            await clicker.setAsset('assets/click.mov');
            clicker.play();
            // ignore: use_build_context_synchronously
            Beamer.of(context).beamToNamed('/grids');
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Already signed in!',
              style: isDarkMode ? darkLargeFont : lightLargeFont,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
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
                  auth.signOut();
                  // ignore: use_build_context_synchronously
                  Beamer.of(context).beamToNamed('/sign-in');
                },
                child: Text(
                  'Sign Out',
                  style: isDarkMode ? lightFont : darkFont,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () async {
                await clicker.setAsset('assets/click.mov');
                clicker.play();
                showDialog(
                    // ignore: use_build_context_synchronously
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor:
                            isDarkMode ? Colors.black : Colors.white,
                        title: Text(
                          'Are you sure you want to delete your account?',
                          style: isDarkMode ? darkLargeFont : lightLargeFont,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              await clicker.setAsset('assets/click.mov');
                              clicker.play();
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Cancel',
                              style:
                                  isDarkMode ? darkSmallFont : lightSmallFont,
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              try {
                                auth.deleteAccount();
                                db.deleteUser(userID: auth.user!.uid);
                              } catch (e) {
                                showMessage(e.toString());
                              } finally {
                                await whoosh.setAsset('assets/whoosh.mov');
                                whoosh.play();
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context);
                                // ignore: use_build_context_synchronously
                                Beamer.of(context).beamToNamed('/sign-in');
                              }
                            },
                            child: Text(
                              'Delete',
                              style:
                                  isDarkMode ? darkSmallFont : lightSmallFont,
                            ),
                          ),
                        ],
                      );
                    });
              },
              child: Text(
                'Delete Account',
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
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        )),
      ),
    );
  }
}
