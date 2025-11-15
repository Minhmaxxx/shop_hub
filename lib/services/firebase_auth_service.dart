import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseAuthService();

  // Stream để lắng nghe auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Đăng ký bằng email/password
  Future<UserCredential?> registerWithEmail(String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred;
  }

  // Đăng nhập bằng email/password
  Future<UserCredential?> loginWithEmail(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred;
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Các phương thức social: để stub (bổ sung implementation nếu cần)
  Future<UserCredential?> signInWithGoogle() async {
    // TODO: Implement Google Sign-In (google_sign_in + Firebase Auth)
    throw UnimplementedError('Google Sign-In chưa được triển khai trong FirebaseAuthService.');
  }

  Future<UserCredential?> signInWithFacebook() async {
    // TODO: Implement Facebook Sign-In
    throw UnimplementedError('Facebook Sign-In chưa được triển khai trong FirebaseAuthService.');
  }
}