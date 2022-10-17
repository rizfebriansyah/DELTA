import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

//v2
enum AuthResultStatus {
  successful,
  emailAlreadyExists,
  wrongPassword,
  weakPassword,
  invalidEmail,
  nothing,
  userNotFound,
  userDisabled,
  undefined,
  test
}

class FirebaseAuthHelper {
  final _auth = FirebaseAuth.instance;

  //added late infront
  AuthResultStatus _status = AuthResultStatus.test;


//   Future<String> login({email, pass}) async {
//     try {
//       final authResult =
//       await _auth.signInWithEmailAndPassword(email: email, password: pass);
//
//       if (authResult.user != null) {
//         _status = AuthResultStatus.successful;
//       } else {
//         _status = AuthResultStatus.undefined;
//       }
//     } catch (e) {
//       print('Exception @createAccount: $e');
//       _status = AuthExceptionHandler.handleException(e);
//     }
//     return 'Did not login';
//   }
//   logout() {
//     _auth.signOut();
//   }
// }

  Future<AuthResultStatus> login({required String email, required String pass}) async {
    try {
      final authResult = await _auth.signInWithEmailAndPassword(email: email, password: pass);
      if (authResult.user != null) {
          _status = AuthResultStatus.successful;
        } else {
          _status = AuthResultStatus.undefined;
        }
    } catch (e) {
      print('Exception @createAccount: $e');
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }
  logout() {
    _auth.signOut();
  }
}


class AuthExceptionHandler {
  static handleException(e) {
    print(e.code);
    var status;
    switch (e.code) {
      case "invalid-email":
        status = AuthResultStatus.invalidEmail;
        break;
      case "wrong-password":
        status = AuthResultStatus.wrongPassword;
        break;
      case "weak-password":
        status = AuthResultStatus.weakPassword;
        break;
      case "user-not-found":
        status = AuthResultStatus.userNotFound;
        break;
      case "user-disabled":
        status = AuthResultStatus.userDisabled;
        break;
      case "email-already-in-use":
        status = AuthResultStatus.emailAlreadyExists;
        break;
      case "unknown":
        status = AuthResultStatus.nothing;
        break;
      default:
        status = AuthResultStatus.undefined;
    }
    return status;
  }

  static generateExceptionMessage(exceptionCode) {
    String errorMessage;
    switch (exceptionCode) {
      case AuthResultStatus.invalidEmail:
        errorMessage = "Your email address appears to be malformed.";
        break;
      case AuthResultStatus.wrongPassword:
        errorMessage = "Your password is wrong.";
        break;
      case AuthResultStatus.weakPassword:
        errorMessage = "Your password is too weak. It must have at least 6 characters.";
        break;
      case AuthResultStatus.userNotFound:
        errorMessage = "User with this email doesn't exist.";
        break;
      case AuthResultStatus.userDisabled:
        errorMessage = "User with this email has been disabled.";
        break;
      case AuthResultStatus.emailAlreadyExists:
        errorMessage =
        "The email has already been registered. Please login or reset your password.";
        break;
      case AuthResultStatus.nothing:
        errorMessage =
        "Enter your details correctly.";
        break;
      default:
        errorMessage = "Please try again.";
    }

    return errorMessage;
  }
}



// class AuthenticationService{
//   final FirebaseAuth _firebaseAuth;
//
//   AuthenticationService(this._firebaseAuth);
//   //added a ? beside User
//   Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
//
//   //sign in method
//   //Added a ? beside String
//   Future<String?> signIn({required String email, required String password}) async {
//     try{
//       await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
//       return "Signed In";
//     } on FirebaseAuthException catch (e){
//       return e.message;
//     }
//   }
//
// }