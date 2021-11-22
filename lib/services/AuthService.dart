import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static GoogleSignIn googleSignIn = GoogleSignIn();

  GoogleSignInAccount user;

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future logout() async {
    try {
      await googleSignIn.disconnect();
      await FirebaseAuth.instance.signOut();
      return true;
    } catch (e) {
      return null;
    }
  }

  Future<UserCredential> createUser(String email, String password) async {
    UserCredential _userCredential;
    _userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    return _userCredential;
  }

  Future<UserCredential> signInWithEmailAndPassword(
          String email, String password) async =>
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
}
