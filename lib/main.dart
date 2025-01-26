import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/firebase_options.dart';
import 'logic/routes/routes.dart';
import 'logic/providers/providers.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.grey[900],
  ));
  runApp(const ProviderScope(child: Grids()));
}

class Grids extends ConsumerWidget {
  const Grids({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(darkMode);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerDelegate: routerDelegate,
      routeInformationParser: BeamerParser(),
      themeMode: ThemeMode.system,
      theme: ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark(
          primary: Colors.teal,
          secondary: Colors.tealAccent,
        ),
        primaryColor: isDarkMode ? Colors.grey[900] : Colors.grey[100],
        scaffoldBackgroundColor:
            isDarkMode ? Colors.grey[900] : Colors.grey[100],
        appBarTheme: AppBarTheme(
          color: isDarkMode ? Colors.grey[900] : Colors.grey[100],
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.grey[900],
          ),
        ),
      ),
    );
  }
}
