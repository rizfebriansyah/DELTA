import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_app/pages/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

//This is the main application widget
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: LoginScreen());

    // return MultiProvider(
    //   providers: [
    //     Provider<AuthenticationService>(
    //       create: (_) => AuthenticationService(FirebaseAuth.instance),
    //     ),
    //     StreamProvider(
    //       create: (context) => context.read<AuthenticationService>().authStateChanges, initialData: null,
    //      ),
    //     ],
    //     child: MaterialApp(
    //       title: 'Flutter demo',
    //       theme: ThemeData(
    //         primarySwatch: Colors.blue,
    //           visualDensity: VisualDensity.adaptivePlatformDensity,
    //       ),
    //     home: AuthenticationWrapper()
    // ));
  }
}
  //added - to return the home page/ login page (depends if you are authenticated)
// class AuthenticationWrapper extends StatelessWidget{
//    const AuthenticationWrapper({
//       Key? key,
//     }) : super(key:key);
//
//
//   @override
//   Widget build(BuildContext context) {
//     final firebaseUser = context.watch<User>();
//
//     if (firebaseUser != null){
//       return MainPage();
//     }
//     return LoginScreen();
//   }





