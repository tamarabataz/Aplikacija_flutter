import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  static bool _isCurrentUserAdmin = false;

  static bool get isLoggedIn => FirebaseAuth.instance.currentUser != null;
  static bool get isCurrentUserAdmin => _isCurrentUserAdmin;

  Future<UserCredential> signUp(
    String name,
    String email,
    String password,
  ) async {
    final credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    final user = credential.user;
    if (user != null) {
      final userDocRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final userDoc = await userDocRef.get();
      final existingRole = userDoc.data()?['role'] ?? 'user';

      await userDocRef.set(
        {
          'name': name,
          'email': email,
          'role': existingRole,
          'createdAt': Timestamp.now(),
        },
        SetOptions(merge: true),
      );
    }

    _isCurrentUserAdmin = false;
    return credential;
  }

  Future<UserCredential> login(String email, String password) async {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    await isAdmin();
    return credential;
  }

  Future<void> logout() async {
    _isCurrentUserAdmin = false;
    await FirebaseAuth.instance.signOut();
  }

  Stream<User?> get authStateChanges => FirebaseAuth.instance.authStateChanges();

  Future<bool> isAdmin() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _isCurrentUserAdmin = false;
      return false;
    }

    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    final isAdminRole = userDoc.data()?['role'] == 'admin';
    _isCurrentUserAdmin = isAdminRole;
    return isAdminRole;
  }
}
