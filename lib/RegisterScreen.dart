import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late FirebaseAuth _auth;
  String email = '';
  String password = '';
  String confirmPassword = '';

  @override
  void initState() {
    super.initState();
    initFirebase();
  }

  void initFirebase() async {
    await Firebase.initializeApp();
    _auth = FirebaseAuth.instance;
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
                       "Register Account",
                       style: TextStyle(
                           fontSize: 30
                       ),
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
                          borderSide: const BorderSide(color: Colors.redAccent, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.redAccent, width: 2.0),
                        ),
                        prefixIcon: const Icon(
                          Icons.person_outlined,
                          color: Color.fromRGBO(0, 0, 0, 100),
                        ),
                        hintText: 'E-mail',
                      ),
                    )
                ),
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
                          borderSide: const BorderSide(color: Colors.redAccent, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.redAccent, width: 2.0),
                        ),
                        prefixIcon: const Icon(
                          Icons.vpn_key_outlined,
                          color: Color.fromRGBO(0, 0, 0, 100),
                        ),
                        hintText: 'Password',
                      ),
                    )
                ),
                Container(
                    margin: const EdgeInsets.fromLTRB(35, 0, 35, 30),
                    child: TextField(
                      onChanged: (value) {
                        confirmPassword = value;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.redAccent, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.redAccent, width: 2.0),
                        ),
                        prefixIcon: const Icon(
                          Icons.vpn_key_outlined,
                          color: Color.fromRGBO(0, 0, 0, 100),
                        ),
                        hintText: 'Confirm Password',
                      ),
                    )
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (password.length < 6) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Password must be at least 6 characters.'),
                            duration: Duration(seconds: 3), // Change the duration as needed
                          ),
                        );
                      }

                      if (password != confirmPassword) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please make sure your passwords match.'),
                            duration: Duration(seconds: 3), // Change the duration as needed
                          ),
                        );
                      }

                      if (!email.contains('@') && email.length < 6) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Email entered is invalid.'),
                            duration: Duration(seconds: 3), // Change the duration as needed
                          ),
                        );
                      }
                      try {
                        final newUser = await _auth.createUserWithEmailAndPassword(
                            email: email, password: password);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Registration successful!'),
                            duration: Duration(seconds: 3), // Change the duration as needed
                          ),
                        );

                        Navigator.pushNamed(context, '/login');
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('This email address is already registered.'),
                            duration: Duration(seconds: 3), // Change the duration as needed
                          ),
                        );
                      }

                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.redAccent,
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
                        'Register',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: TextButton(
                    onPressed: () { Navigator.pushNamed(context, '/login'); },
                    child: const Text(
                      "Back to login",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.redAccent,
                        fontSize: 15
                      ),
                    ),
                  ),
                ),
              ],
            )
        ),
      )
    );
  }
}
