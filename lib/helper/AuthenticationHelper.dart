import 'package:firebase_auth/firebase_auth.dart';
import 'package:saloon_app/models/AppUser.dart';
import 'package:saloon_app/models/AuthCallback.dart';

class AuthenticationHelper {
  static Future<User> signUserIn(AppUser appUser, Function callbacks) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: appUser.email, password: appUser.password);
      callbacks.call(AuthCallback('Login success', false));
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        callbacks.call(AuthCallback('No user found for that email.', true));
        return null;
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        callbacks.call(AuthCallback('Incorrect password provided.', true));
        return null;
      }
    }
  }

  static Future<User> signUserUp(AppUser appUser, Function callbacks) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: appUser.email, password: appUser.password);
      callbacks.call(AuthCallback('Registration success', false));
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        callbacks.call(AuthCallback('The password provided is too weak.', true));
        return null;
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        callbacks.call(AuthCallback('The account already exists for that email.', true));
        return null;
      }
    } catch (e) {
      print(e);
    }
  }
}
