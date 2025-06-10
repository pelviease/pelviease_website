import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pelviease_website/backend/models/user_model.dart';

// AuthService class
class AuthService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  // Convert Firebase User to UserModel
  Future<UserModel> _userFromFirebase(
    User? firebaseUser, {
    Map<String, dynamic>? additionalData,
  }) async {
    if (firebaseUser == null) {
      throw Exception("No user found");
    }

    final doc =
        await _firestore.collection('users').doc(firebaseUser.uid).get();
    final data = doc.data();

    return UserModel(
      id: firebaseUser.uid,
      name:
          data?['name'] as String? ?? additionalData?['name'] as String? ?? '',
      email: firebaseUser.email ?? '',
      isDoctor: data?['isDoctor'] as bool? ??
          additionalData?['isDoctor'] as bool? ??
          false,
    );
  }

  // Get current user
  Future<UserModel?> getCurrentUser() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;
    return await _userFromFirebase(firebaseUser);
  }

  // Login with email and password
  Future<UserModel> login(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return await _userFromFirebase(userCredential.user);
    } catch (e) {
      throw Exception(_mapFirebaseError(e));
    }
  }

  // Signup with email, password, name, and isDoctor
  Future<UserModel> signup(
    String name,
    String email,
    String password,
    bool isDoctor,
  ) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'name': name.trim(),
          'email': email.trim(),
          'isDoctor': isDoctor,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return await _userFromFirebase(
        user,
        additionalData: {'name': name, 'isDoctor': isDoctor},
      );
    } catch (e) {
      throw Exception(_mapFirebaseError(e));
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception("Failed to logout: ${e.toString()}");
    }
  }

  // Map Firebase errors to user-friendly messages
  String _mapFirebaseError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'No user found with this email.';
        case 'wrong-password':
          return 'Incorrect password.';
        case 'email-already-in-use':
          return 'This email is already in use.';
        case 'invalid-email':
          return 'Invalid email address.';
        case 'weak-password':
          return 'Password is too weak.';
        case 'too-many-requests':
          return 'Too many attempts. Please try again later.';
        default:
          return 'Authentication failed: ${error.message ?? error.code}';
      }
    }
    return 'An error occurred: ${error.toString()}';
  }
}
