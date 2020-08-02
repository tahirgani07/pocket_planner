import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_and_tax_planning_app/models/financial/accounts_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

/*  // create user obj based on FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }*/

  // auth change user stream
  Stream<FirebaseUser> get user {
    return _auth.onAuthStateChanged;
  }

  Future loginWithGoogle() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount account = await googleSignIn.signIn();

      AuthResult res = await _auth.signInWithCredential(
        GoogleAuthProvider.getCredential(
          idToken: (await account.authentication).idToken,
          accessToken: (await account.authentication).accessToken,
        ),
      );

      FirebaseUser user = res.user;

      // Checking to see if user is logging in first time.
      DocumentSnapshot ds =
          await Firestore.instance.collection('main').document(user.uid).get();
      if (ds.data == null) {
        Firestore.instance
            .collection('main')
            .document(user.uid)
            .setData({'cashAccountAdded': true});

        ///when you change this make the above line false.
        AccountsModel().addNewAccount(
          user.uid,
          "CASH",
          0,
          '',
        );
      }

      return user;
    } catch (e) {
      print("Error logging in with google : " + e.toString());
      return null;
    }
  }

  Future logOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print("error loggin out " + e.toString());
      return null;
    }
  }
}
