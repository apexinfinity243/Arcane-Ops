import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Auth Methods
  Future<UserCredential?> signUpWithEmail(
    String email,
    String password,
  ) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<UserCredential?> signInWithEmail(
    String email,
    String password,
  ) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> signUpWithPhone(String phoneNumber) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          throw _handleAuthException(e);
        },
        codeSent: (String verificationId, int? resendToken) {
          // Handle code sent
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Handle timeout
        },
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> verifyPhoneCode(
    String verificationId,
    String code,
  ) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: code,
      );
      await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> verifyEmailCode(String code) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Mark email as verified in Firestore
        await _firestore.collection('users').doc(user.uid).update({
          'emailVerified': true,
          'verifiedAt': DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {
      throw 'Erreur lors de la vérification: $e';
    }
  }

  // Save user data to Firestore
  Future<void> saveUserData(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set(user.toJson());
    } catch (e) {
      throw 'Erreur lors de la sauvegarde: $e';
    }
  }

  // Get user data
  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw 'Erreur lors de la récupération: $e';
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw 'Erreur lors de la déconnexion: $e';
    }
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Check if user is authenticated
  bool isAuthenticated() {
    return _auth.currentUser != null;
  }

  // Send verification email
  Future<void> sendVerificationEmail() async {
    try {
      User? user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } catch (e) {
      throw 'Erreur lors de l\'envoi de l\'email: $e';
    }
  }

  // Handle auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'Le mot de passe est trop faible';
      case 'email-already-in-use':
        return 'Cet email est déjà utilisé';
      case 'invalid-email':
        return 'Email invalide';
      case 'user-not-found':
        return 'Utilisateur non trouvé';
      case 'wrong-password':
        return 'Mot de passe incorrect';
      case 'user-disabled':
        return 'Compte désactivé';
      default:
        return 'Erreur: ${e.message}';
    }
  }
}
