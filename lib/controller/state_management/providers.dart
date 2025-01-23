import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/data/auth/firebase_auth.dart';
import '/data/database/firestore_database.dart';
import '../validation/validation.dart';

// Firebase Auth Service
final firebaseAuth = StateProvider((ref) => FirebaseAuthService());

// Firestore Service
final firestore = StateProvider((ref) => FirestoreService());

// dark/ light mode
final darkMode = StateProvider((ref) => true);

// Validation
final validation = StateProvider((ref) => Validation());

// Magnitude of current grid
final xProvider = StateProvider((ref) => 7);
final yProvider = StateProvider((ref) => 52);

// Whether toolbar on GridPage is anchored to top or bottom
final barBottom = StateProvider((ref) => true);
