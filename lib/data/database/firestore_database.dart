import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/colour_conversions.dart';
import '../model/grid_model.dart';
import '../model/user_model.dart';

class FirestoreService {
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');
  final colourConverter = ColourConversions();

  // Create a user
  Future<void> addUser({required UserModel user}) async {
    try {
      await _users.doc(user.id).set({
        'id': FirebaseAuth.instance.currentUser!.uid,
        'email': user.email,
        'name': user.name,
      });
    } catch (e) {
      rethrow;
    }
  }

  // Get a user
  Future<UserModel> getUser({required String userID}) async {
    try {
      final user = await _users.doc(userID).get();
      return UserModel(
        id: user['id'],
        email: user['email'],
        name: user['name'],
      );
    } catch (e) {
      rethrow;
    }
  }

  // Update user
  Future<void> updateUser({required UserModel user}) async {
    try {
      await _users.doc(user.id).update({
        'id': user.id,
        'email': user.email,
        'name': user.name,
      });
    } catch (e) {
      rethrow;
    }
  }

  // Delete user
  Future<void> deleteUser({required String userID}) async {
    try {
      await _users.doc(userID).delete();
    } catch (e) {
      rethrow;
    }
  }

  // Create a grid
  Future<void> addGrid({required GridModel grid}) async {
    try {
      await _users
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('grids')
          .doc(grid.gridID)
          .set({
        'gridID': grid.gridID,
        'title': grid.title,
        'image': grid.image,
        'dateModified': grid.dateModified,
        'x': grid.x,
        'y': grid.y,
        'colours': grid.colours,
        'shape': grid.shape,
        'gridValues': grid.gridValues,
      });
    } catch (e) {
      rethrow;
    }
  }

  // Get a grid
  Future<GridModel> getGrid({required String gridID}) async {
    try {
      final grid = await _users
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('grids')
          .doc(gridID)
          .get();
      return GridModel(
        gridID: grid['gridID'],
        title: grid['title'],
        image: grid['image'],
        dateModified: grid['dateModified'],
        x: grid['x'],
        y: grid['y'],
        colours: grid['colours'],
        shape: grid['shape'],
        gridValues: grid['gridValues'],
      );
    } catch (e) {
      rethrow;
    }
  }

  // Get grids
  Future<List<GridModel>> getGrids() async {
    try {
      final grids = await _users
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('grids')
          .orderBy('dateModified', descending: true)
          .get();
      return grids.docs
          .map((grid) => GridModel(
                gridID: grid['gridID'],
                title: grid['title'],
                image: grid['image'],
                dateModified: grid['dateModified'],
                x: grid['x'],
                y: grid['y'],
                colours: grid['colours'],
                shape: grid['shape'],
                gridValues: grid['gridValues'],
              ))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Update grid
  Future<void> updateGrid({required GridModel grid}) async {
    try {
      await _users
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('grids')
          .doc(grid.gridID)
          .update({
        'gridID': grid.gridID,
        'title': grid.title,
        'image': grid.image,
        'dateModified': grid.dateModified,
        'x': grid.x,
        'y': grid.y,
        'colours': grid.colours,
        'shape': grid.shape,
        'gridValues': grid.gridValues,
      });
    } catch (e) {
      rethrow;
    }
  }

  // Delete grid
  Future<void> deleteGrid({required String gridID}) async {
    try {
      await _users
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('grids')
          .doc(gridID)
          .delete();
    } catch (e) {
      rethrow;
    }
  }
}
