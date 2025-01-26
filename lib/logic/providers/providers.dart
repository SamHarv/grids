import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/auth.dart';
import '../../data/database/firestore.dart';
import '../services/url_launcher.dart';
import '../services/validation.dart';

/// Singleton for [Auth]
final authentication = StateProvider((ref) => Auth());

/// Singleton for [Firestore] database
final firestore = StateProvider((ref) => Firestore());

/// dark/ light mode
final darkMode = StateProvider((ref) => true);

/// Singleton for Validation
final validation = StateProvider((ref) => Validation());

/// Provide singleton for [UrlLauncher]
final url = StateProvider((ref) => UrlLauncher());

/// Magnitude of current grid - default to 52 rows of 7 columns to represent
/// a year
final xProvider = StateProvider((ref) => 7);
final yProvider = StateProvider((ref) => 52);

/// Whether toolbar on [GridPage] is anchored to top or bottom
final barBottom = StateProvider((ref) => true);
