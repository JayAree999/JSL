import 'package:eat_local/ApiServices/RestaurantUtil.dart';
import 'package:eat_local/SavedPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late FirebaseAuth _auth;
  String email = '';
  String password = '';
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    initFirebase();
    saveRestaurants();
  }

  void initFirebase() async {
    await Firebase.initializeApp();
    _auth = FirebaseAuth.instance;
    final user = _auth.currentUser;
    if (user != null) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SavedPage()),
          (Route<dynamic> route) => false);
    }
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.white;
    }
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(50, 30, 50, 0),
            child: Image.asset(
              'assets/images/logo_transparent.png',
              height: 300,
              width: 300,
            ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: const Text(
                "Login to your account",
                style: TextStyle(fontSize: 30),
              ),
            ),
          ),
          Container(
              margin: const EdgeInsets.fromLTRB(35, 20, 35, 25),
              child: TextField(
                onChanged: (value) {
                  email = value;
                },
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: Colors.redAccent, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: Colors.redAccent, width: 2.0),
                  ),
                  prefixIcon: const Icon(
                    Icons.person_outlined,
                    color: Color.fromRGBO(0, 0, 0, 100),
                  ),

                  hintText: 'E-mail',
                ),
              )),
          Container(
              margin: const EdgeInsets.fromLTRB(35, 0, 35, 25),
              child: TextField(
                onChanged: (value) {
                  password = value;
                },
                obscureText: true,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: Colors.redAccent, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: Colors.redAccent, width: 2.0),
                  ),
                  prefixIcon: const Icon(
                    Icons.vpn_key_outlined,
                    color: Color.fromRGBO(0, 0, 0, 100),
                  ),
                  hintText: 'Password',
                ),
              )),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                try {
                  final user = await _auth.signInWithEmailAndPassword(
                      email: email, password: password);
                  if (user != null) {
                    Navigator.pushNamed(context, '/saved');
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('E-mail or password is incorrect.'),
                      duration:
                          Duration(seconds: 3), // Change the duration as needed
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 5.0,
              ),
              child: Container(
                width: 320,
                height: 55,
                alignment: Alignment.center,
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ),
          ),
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text(
                "Signup",
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.redAccent,
                    fontSize: 15),
              ),
            ),
          ),
          Center(
            child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/location');
                },
                child: const Text(
                  "Enter as guest",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.redAccent,
                      fontSize: 15),
                )),
          ),
        ],
      )),
    ));
  }
}
