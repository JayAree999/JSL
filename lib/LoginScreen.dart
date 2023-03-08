import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(bottom: 52, left: 12, right: 12),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 38.49),
              const SizedBox(
                width: 300,
                height: 300,
                child: FlutterLogo(size: 300),
              ),
              const SizedBox(height: 38.49),
              const Text(
                "Login To Your Account",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 38.49),
              Container(
                width: 323,
                height: 57,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xffea3f30), width: 1,),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.only(
                  left: 10, right: 212, top: 10, bottom: 17,),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Opacity(
                      opacity: 0.50,
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: FlutterLogo(size: 30),
                      ),
                    ),
                    SizedBox(width: 11),
                    Opacity(
                      opacity: 0.50,
                      child: Text(
                        "E-mail",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 38.49),
              Container(
                width: 323,
                height: 57,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xffea3f30), width: 1,),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.only(
                  left: 10, right: 179, top: 11, bottom: 16,),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Opacity(
                      opacity: 0.50,
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: FlutterLogo(size: 30),
                      ),
                    ),
                    SizedBox(width: 11),
                    Opacity(
                      opacity: 0.50,
                      child: Text(
                        "Password",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 38.49),
              const SizedBox(
                width: 134,
                height: 14,
                child: Text(
                  "Keep me logged in",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(height: 38.49),
              const SizedBox(
                width: 109,
                height: 14,
                child: Text(
                  "Forgot Password?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                  ),
                ),
              ),
              const SizedBox(height: 38.49),
              Container(
                width: 323,
                height: 57,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x3f000000),
                      blurRadius: 4,
                      offset: Offset(0, 4),
                    ),
                  ],
                  color: const Color(0xffea3f30),
                ),
                padding: const EdgeInsets.only(
                  left: 136, right: 135, top: 17, bottom: 16,),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 38.49),
              const SizedBox(
                width: 174,
                height: 14,
                child: Text(
                  "Signup",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xffea3f30),
                    fontSize: 15,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 38.49),
              const SizedBox(
                width: 174,
                height: 14,
                child: Text(
                  "Continue as Guest",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
