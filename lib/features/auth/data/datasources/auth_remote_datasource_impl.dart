import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_model.dart';
import 'auth_remote_datasource.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
  }) : _auth = firebaseAuth,
       _googleSignIn = googleSignIn;

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  UserModel? _map(User? user) {
    if (user == null) return null;
    return UserModel.fromFirebase(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      emailVerified: user.emailVerified,
    );
  }

  @override
  Stream<UserModel?> authStateChanges() => _auth.authStateChanges().map(_map);

  @override
  UserModel? get currentUser => _map(_auth.currentUser);

  @override
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = _map(cred.user);
    if (user == null || user.id.isEmpty) {
      throw FirebaseAuthException(code: 'invalid-credential');
    }
    return user;
  }

  @override
  Future<UserModel> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final trimmed = name.trim();
    if (trimmed.isNotEmpty) {
      await cred.user?.updateDisplayName(trimmed);
      await cred.user?.reload();
    }
    final current = _auth.currentUser;
    final user = _map(current ?? cred.user);
    if (user == null || user.id.isEmpty) {
      throw FirebaseAuthException(code: 'operation-not-allowed');
    }
    return user;
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    if (kIsWeb) {
      final provider = GoogleAuthProvider();
      final cred = await _auth.signInWithPopup(provider);
      final user = _map(cred.user);
      if (user == null || user.id.isEmpty) {
        throw FirebaseAuthException(code: 'invalid-credential');
      }
      return user;
    }

    final GoogleSignInAccount account;
    try {
      account = await _googleSignIn.authenticate();
    } on GoogleSignInException {
      rethrow;
    }

    final GoogleSignInAuthentication googleAuth;
    try {
      googleAuth = account.authentication;
    } catch (e) {
      debugPrint('GoogleSignIn authentication error: $e');
      throw const GoogleSignInException(
        code: GoogleSignInExceptionCode.canceled,
        description: 'Failed to get Google authentication tokens.',
      );
    }

    final idToken = googleAuth.idToken;
    if (idToken == null || idToken.isEmpty) {
      debugPrint(
        'GoogleSignIn idToken is null. '
        'Ensure SHA-1 fingerprint is registered in Firebase Console.',
      );
      throw const GoogleSignInException(
        code: GoogleSignInExceptionCode.canceled,
        description: 'Failed to get Google ID token. Check Firebase SHA keys.',
      );
    }

    final credential = GoogleAuthProvider.credential(idToken: idToken);
    final cred = await _auth.signInWithCredential(credential);
    final user = _map(cred.user);
    if (user == null || user.id.isEmpty) {
      throw FirebaseAuthException(code: 'invalid-credential');
    }
    return user;
  }

  @override
  Future<void> signOut() async {
    await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
  }
}
