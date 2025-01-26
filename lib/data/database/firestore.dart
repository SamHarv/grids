import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../logic/services/colour_conversion.dart';
import '../models/grid_model.dart';
import '../models/user_model.dart';

class Firestore {
  /// Class to access [Firestore] database

  final _users = FirebaseFirestore.instance.collection('users');
  final colourConverter = ColourConversion();

  /// Create a user
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

  /// Get a user
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

  /// Update user
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

  /// Delete user
  Future<void> deleteUser({required String userID}) async {
    try {
      await _users.doc(userID).delete();
    } catch (e) {
      rethrow;
    }
  }

  /// Create a grid
  Future<void> addGrid({required Grid grid}) async {
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

  /// Get a grid
  Future<Grid> getGrid({required String gridID}) async {
    try {
      final grid = await _users
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('grids')
          .doc(gridID)
          .get();
      return Grid(
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

  /// Get all grids for current user
  Future<List<Grid>> getGrids() async {
    try {
      final grids = await _users
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('grids')
          .orderBy('dateModified', descending: true)
          .get();
      return grids.docs
          .map((grid) => Grid(
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

  /// Update a grid
  Future<void> updateGrid({required Grid grid}) async {
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

  /// Delete a grid
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
