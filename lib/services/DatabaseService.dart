import 'package:basecode/services/AuthService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class DatabaseService {
  static CollectionReference _users =
      FirebaseFirestore.instance.collection("users");
  static AuthService _authService = AuthService();

  Future<UserCredential> registerUser(user) async {
    try {
      var checkEmail = await _users.where("email", isEqualTo: user.email).get();

      if (checkEmail.docs.length > 0) {
        return null;
      }

      UserCredential userCredential = 
          await _authService.createUser(user.email, user.password);

      await _users.doc(userCredential.user.uid).set({
        "firstName": user.firstName,
        "lastName": user.lastName,
        "email": user.email
      }); //same one with the id generated from authentication with the collection made

      return userCredential;
    } catch (e) {
        return null;
    }
  }
}
