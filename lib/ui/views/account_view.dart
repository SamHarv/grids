import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../logic/providers/providers.dart';
import '../../config/constants.dart';

class AccountView extends ConsumerStatefulWidget {
  /// UI to manage user account

  const AccountView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AccountViewWidgetState();
}

class _AccountViewWidgetState extends ConsumerState<AccountView> {
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
    final auth = ref.read(authentication);
    final db = ref.read(firestore);
    final urlLauncher = ref.read(url);
    final mediaWidth = MediaQuery.sizeOf(context).width;
    final isDarkMode = ref.watch(darkMode);

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
            // Back to grids. page
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
                style: isDarkMode ? darkModeLargeFont : lightModeLargeFont,
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
                  // Sign out
                  onPressed: () async {
                    await clicker.setAsset('assets/click.mov');
                    clicker.play();
                    auth.signOut();
                    // ignore: use_build_context_synchronously
                    Beamer.of(context).beamToNamed('/sign-in');
                  },
                  child: Text(
                    'Sign Out',
                    style: isDarkMode ? lightModeFont : darkModeFont,
                  ),
                ),
              ),
              gapH20,
              // Delete account
              TextButton(
                onPressed: () async {
                  await clicker.setAsset('assets/click.mov');
                  clicker.play();
                  // Confirm deletion
                  showDialog(
                      // ignore: use_build_context_synchronously
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor:
                              isDarkMode ? Colors.black : Colors.white,
                          title: Text(
                            'Are you sure you want to delete your account?',
                            style: isDarkMode
                                ? darkModeLargeFont
                                : lightModeLargeFont,
                          ),
                          actions: [
                            // Cancel deletion
                            TextButton(
                              onPressed: () async {
                                await clicker.setAsset('assets/click.mov');
                                clicker.play();
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Cancel',
                                style: isDarkMode
                                    ? darkModeSmallFont
                                    : lightModeSmallFont,
                              ),
                            ),
                            // Delete account
                            TextButton(
                              onPressed: () async {
                                try {
                                  // Delete account from auth
                                  auth.deleteAccount();
                                  // Delete account from firestore
                                  db.deleteUser(userID: auth.user!.uid);
                                } catch (e) {
                                  showMessage(
                                      e.toString(), context, isDarkMode);
                                } finally {
                                  await whoosh.setAsset('assets/whoosh.mov');
                                  whoosh.play();
                                  // Pop dialog
                                  // ignore: use_build_context_synchronously
                                  Navigator.pop(context);
                                  // ignore: use_build_context_synchronously
                                  Beamer.of(context).beamToNamed('/sign-in');
                                }
                              },
                              child: Text(
                                'Delete',
                                style: isDarkMode
                                    ? darkModeSmallFont
                                    : lightModeSmallFont,
                              ),
                            ),
                          ],
                        );
                      });
                },
                child: Text(
                  'Delete Account',
                  style: isDarkMode ? darkModeSmallFont : lightModeSmallFont,
                ),
              ),
              gapH10,
              // Logo to launch O2Tech website
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
                  },
                ),
              ),
              gapH20,
            ],
          ),
        ),
      ),
    );
  }
}
